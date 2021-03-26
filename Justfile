run:
	elm-app start

publish:
	@echo "----! Remember to run 'make gen.pdf' and commit before publishing"
	@echo "----> Publishing to netlify"
	@elm-app build && netlify deploy --prod

gen-pdf:
	npm run generate-pdf