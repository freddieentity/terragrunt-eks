.PHONY: docs

default:
	echo "Nothing to do"

lint:
	terraform fmt
	terraform init && terraform validate

docs:
	terraform-docs --sort-by required md . > docs/variables_and_outputs.md
