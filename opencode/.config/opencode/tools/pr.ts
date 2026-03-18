import { tool } from "@opencode-ai/plugin";

// Determine repo from git remote, falling back to a provided value
async function getRepo(
  repoOverride: string | undefined,
  context: { worktree: string }
): Promise<string> {
  if (repoOverride) return repoOverride;
  const result =
    await Bun.$`git -C ${context.worktree} remote get-url origin`.text();
  const url = result.trim();
  // handles both https://github.com/owner/repo and git@github.com:owner/repo
  const match = url.match(/github\.com[:/](.+?)(?:\.git)?$/);
  if (!match?.[1])
    throw new Error(`Could not parse repo from remote URL: ${url}`);
  return match[1];
}

// ── GitHub API shapes ────────────────────────────────────────────────────────

interface GhUser {
  login: string;
}

interface GhInlineComment {
  path: string;
  line: number | null;
  original_line: number | null;
  body: string;
  diff_hunk: string;
  user: GhUser;
}

interface GhReview {
  id: number;
  state: string;
  body: string;
  user: GhUser;
}

interface GhPr {
  head: { sha: string };
}

interface GhCheckRun {
  id: number;
  name: string;
  status: string;
  conclusion: string | null;
  html_url: string;
}

interface GhCheckRunsResponse {
  check_runs: GhCheckRun[];
}

interface GhJob {
  id: number;
  name: string;
  conclusion: string | null;
}

interface GhJobsResponse {
  jobs: GhJob[];
}

// ── Tools ────────────────────────────────────────────────────────────────────

export const comments = tool({
  description:
    "Read all review comments (inline + review-level) on a GitHub PR. Returns structured output grouped by file path.",
  args: {
    pr: tool.schema.number().describe("PR number"),
    repo: tool.schema
      .string()
      .optional()
      .describe(
        "Repo in owner/name format. Defaults to the current git remote."
      ),
  },
  async execute(args, context) {
    const repo = await getRepo(args.repo, context);

    const [inline, reviews] = await Promise.all([
      Bun.$`gh api repos/${repo}/pulls/${args.pr}/comments --paginate`.json() as Promise<
        GhInlineComment[]
      >,
      Bun.$`gh api repos/${repo}/pulls/${args.pr}/reviews --paginate`.json() as Promise<
        GhReview[]
      >,
    ]);

    // For each pending/submitted review, fetch its comments
    const reviewComments = await Promise.all(
      reviews
        .filter((r) => r.body || r.state !== "PENDING")
        .map(async (r) => {
          const rc =
            (await Bun.$`gh api repos/${repo}/pulls/${args.pr}/reviews/${r.id}/comments`.json()) as GhInlineComment[];
          return { review: r, comments: rc };
        })
    );

    const grouped: Record<
      string,
      { line: number | null; body: string; author: string; diffHunk: string }[]
    > = {};

    for (const c of inline) {
      const key = c.path ?? "general";
      (grouped[key] ??= []).push({
        line: c.line ?? c.original_line,
        body: c.body,
        author: c.user?.login,
        diffHunk: c.diff_hunk?.slice(-300),
      });
    }

    const reviewSummary = reviewComments
      .filter((r) => r.review.body || r.comments.length > 0)
      .map((r) => ({
        state: r.review.state,
        author: r.review.user?.login,
        body: r.review.body,
        inlineComments: r.comments.map((c) => ({
          path: c.path,
          line: c.line ?? c.original_line,
          body: c.body,
          diffHunk: c.diff_hunk?.slice(-300),
        })),
      }));

    return JSON.stringify(
      { inlineByFile: grouped, reviews: reviewSummary },
      null,
      2
    );
  },
});

export const diff = tool({
  description: "Read the diff of a GitHub PR.",
  args: {
    pr: tool.schema.number().describe("PR number"),
    repo: tool.schema
      .string()
      .optional()
      .describe(
        "Repo in owner/name format. Defaults to the current git remote."
      ),
    file: tool.schema
      .string()
      .optional()
      .describe("Filter diff to a specific file path"),
  },
  async execute(args, context) {
    const repo = await getRepo(args.repo, context);
    const raw =
      await Bun.$`gh api repos/${repo}/pulls/${args.pr} -H "Accept: application/vnd.github.diff"`.text();
    if (!args.file) return raw;
    // Extract only the section for the requested file
    const sections = raw.split(/^diff --git /m);
    const match = sections.find(
      (s) => s.startsWith(`a/${args.file}`) || s.includes(` b/${args.file}`)
    );
    return match
      ? `diff --git ${match}`
      : `No diff found for file: ${args.file}`;
  },
});

export const ci = tool({
  description:
    "Read the latest GitHub Actions run output for a PR — lists jobs and, for failed jobs, returns their logs. If `job` is provided, returns logs for that specific job name (case-insensitive substring match) regardless of conclusion.",
  args: {
    pr: tool.schema.number().describe("PR number"),
    repo: tool.schema
      .string()
      .optional()
      .describe(
        "Repo in owner/name format. Defaults to the current git remote."
      ),
    job: tool.schema
      .string()
      .optional()
      .describe(
        "Job name (or substring) to fetch logs for. If omitted, only failed job logs are returned."
      ),
  },
  async execute(args, context) {
    const repo = await getRepo(args.repo, context);

    const pr =
      (await Bun.$`gh api repos/${repo}/pulls/${args.pr}`.json()) as GhPr;
    const sha = pr.head?.sha;
    if (!sha) return "Could not determine PR head SHA";

    const checks =
      (await Bun.$`gh api repos/${repo}/commits/${sha}/check-runs --paginate`.json()) as GhCheckRunsResponse;
    const runs: GhCheckRun[] = checks.check_runs ?? [];

    const summary = runs.map((r) => ({
      id: r.id,
      name: r.name,
      status: r.status,
      conclusion: r.conclusion,
      url: r.html_url,
    }));

    // Collect all jobs across all workflow runs (deduplicated by job id)
    const allJobsMap = new Map<number, GhJob>();
    await Promise.all(
      runs.map(async (r) => {
        try {
          const jobs =
            (await Bun.$`gh api repos/${repo}/actions/runs/${r.id}/jobs`.json()) as GhJobsResponse;
          for (const j of jobs.jobs ?? []) allJobsMap.set(j.id, j);
        } catch {
          // ignore
        }
      })
    );
    const allJobs = [...allJobsMap.values()];

    if (args.job) {
      const needle = args.job.toLowerCase();
      const matched = allJobs.filter((j) =>
        j.name.toLowerCase().includes(needle)
      );
      if (matched.length === 0)
        return JSON.stringify(
          {
            summary,
            error: `No job found matching "${
              args.job
            }". Available jobs: ${allJobs.map((j) => j.name).join(", ")}`,
          },
          null,
          2
        );
      const jobLogs = await Promise.all(
        matched.map(async (j) => {
          const log =
            await Bun.$`gh api repos/${repo}/actions/jobs/${j.id}/logs`.text();
          return { job: j.name, conclusion: j.conclusion, log };
        })
      );
      return JSON.stringify({ summary, jobLogs }, null, 2);
    }

    // Default: only failed jobs
    const failed = runs.filter(
      (r) => r.conclusion === "failure" || r.conclusion === "timed_out"
    );

    const logs = await Promise.all(
      failed.map(async (r) => {
        try {
          const jobs =
            (await Bun.$`gh api repos/${repo}/actions/runs/${r.id}/jobs`.json()) as GhJobsResponse;
          const failedJobs = jobs.jobs.filter(
            (j) => j.conclusion === "failure"
          );
          const jobLogs = await Promise.all(
            failedJobs.map(async (j) => {
              const log =
                await Bun.$`gh api repos/${repo}/actions/jobs/${j.id}/logs`.text();
              return { job: j.name, log: log.slice(-3000) };
            })
          );
          return { checkRun: r.name, jobs: jobLogs };
        } catch {
          return { checkRun: r.name, error: "Could not fetch logs" };
        }
      })
    );

    return JSON.stringify({ summary, failedLogs: logs }, null, 2);
  },
});
