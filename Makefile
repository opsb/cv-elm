.PHONY: run
run:
	elm-app start

.PHONY: publish
publish:
	@echo "----! Remember to run 'make gen.pdf' and commit before publishing"
	@echo "----> Publishing to netlify"
	@elm-app build && netlify deploy --prod

.PHONY: gen.pdf
gen.pdf:
	npm run generate-pdf