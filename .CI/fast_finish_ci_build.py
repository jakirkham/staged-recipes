#!/usr/bin/env python

try:
    from future_builtins import (
        map,
        filter,
    )
except ImportError:
    pass

import argparse
import codecs
import contextlib
import json
import os
import sys

try:
    from urllib.request import (
        Request,
        urlopen,
    )
except ImportError:
    from urllib2 import (
        Request,
        urlopen,
    )


def request_json(url, headers={}):
    request = Request(url, headers=headers)
    with contextlib.closing(urlopen(request)) as response:
        reader = codecs.getreader("utf-8")
        return json.load(reader(response))


def travis_check_latest_pr_build(repo, pr, build_num):
    # Not a PR so it is latest.
    if pr is None:
        return True

    headers = {
        "Accept": "application/vnd.travis-ci.2+json",
    }
    url = "https://api.travis-ci.org/repos/{repo}/builds?event_type=pull_request"

    data = request_json(url.format(repo=repo), headers=headers)

    # Parse the response to get a list of build numbers for this PR.
    builds = data["builds"]
    pr_builds = filter(lambda b: b["pull_request_number"] == pr, builds)
    pr_build_nums = sorted(map(lambda b: int(b["number"]), pr_builds))

    # Check if our build number is the latest (largest)
    # out of all of the builds for this PR.
    if build_num < max(pr_build_nums):
        return False
    else:
        return True


def main(*args):
    if not args:
        args = sys.argv[1:]

    parser = argparse.ArgumentParser(
        description="Determine whether this build should end."
    )
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Whether to include output",
    )
    parser.add_argument(
        "--ci",
        required=True,
        choices=[
            "travis",
        ],
        help="Which CI to check for an outdated build",
    )
    parser.add_argument(
        "repo",
        type=str,
        help="GitHub repo name (e.g. `user/repo`.)",
    )
    parser.add_argument(
        "bld",
        type=int,
        help="CI build number for this pull request",
    )
    parser.add_argument(
        "pr",
        nargs="?",
        default="",
        help="GitHub pull request number of this build",
    )

    params = parser.parse_args(args)
    verbose = params.verbose
    ci = params.ci
    repo = params.repo
    bld = params.bld
    try:
        pr = int(params.pr)
    except ValueError:
        pr = None

    if verbose:
        print("Checking to see if this PR build is outdated.")

    exit_code = 0
    if ci == "travis":
        exit_code = int(travis_check_latest_pr_build(repo, pr, bld) is False)

    if verbose and exit_code == 1:
        print("Failing outdated PR build to end it.")

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
