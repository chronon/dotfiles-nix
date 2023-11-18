local utils = require("utils")
local config = require("config")
local keys = require("keys")

require("startup")

config = utils.merge_all(config, keys)

return config
