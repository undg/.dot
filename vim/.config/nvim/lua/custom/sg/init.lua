local type_error = require('custom.sg.type-error')
local commit = require('custom.sg.commit')
local pull_request = require('custom.sg.pull-request')
local readme = require('custom.sg.readme')
local text = require('custom.sg.text')

local M = {}

M.type_error = type_error
M.commit = commit
M.pull_request = pull_request
M.readme = readme
M.text = text

return M
