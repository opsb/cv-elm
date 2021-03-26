run:
	elm-app start

publish: gen-pdf
	@echo "----> Publishing to netlify"
	@elm-app build && netlify deploy --prod

gen-pdf:
	npm run generate-pdf