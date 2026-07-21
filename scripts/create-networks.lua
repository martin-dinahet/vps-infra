#!/usr/bin/env lua

local docker = dofile("scripts/helpers/docker.lua")

docker.ensure_network("frontend")
docker.ensure_network("backend")

print("Docker networks are ready: frontend, backend.")
