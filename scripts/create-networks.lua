#!/usr/bin/env lua

local infra = dofile("scripts/helpers/init.lua")
local docker = infra.docker

docker.ensure_network("frontend")
docker.ensure_network("backend")

print("Docker networks are ready: frontend, backend.")
