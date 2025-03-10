#!/bin/bash

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ ! -f "$(npm root)"/.bin/vue-tsc ]; then
	echo "::group::🔄 Running npm install to install tsc ..."
	npm install
	echo "::endgroup::"
fi

if [ ! -f "$(npm root)"/.bin/vue-tsc ]; then
	echo "❌ Unable to locate or install tsc. Did you provide a workdir which contains a valid package.json?"
	exit 1
else

	echo ℹ️ vue-tsc version: "$("$(npm root)"/.bin/vue-tsc --version)"

	echo "::group::📝 Running vue-tsc with reviewdog 🐶 ..."

	# shellcheck disable=SC2086
	"$(npm root)"/.bin/vue-tsc ${INPUT_TSC_FLAGS} |
		reviewdog -f=tsc \
			-name="${INPUT_TOOL_NAME}" \
			-reporter="${INPUT_REPORTER}" \
			-filter-mode="${INPUT_FILTER_MODE}" \
			-fail-on-error="${INPUT_FAIL_ON_ERROR}" \
			-level="${INPUT_LEVEL}" \
			${INPUT_REVIEWDOG_FLAGS}

	reviewdog_rc=$?
	echo "::endgroup::"
	exit $reviewdog_rc

fi
