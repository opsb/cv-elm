publish: gen-pdf
	@echo "----> Publishing to netlify"
	@npm run build && netlify deploy --prod -d dist

gen-pdf:
	npm run generate-pdf
