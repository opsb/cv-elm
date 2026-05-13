dev:
	npm run dev

publish:
	@npm run build
	@npm run generate-pdf
	@echo "----> Publishing to netlify"
	@netlify deploy --prod -d dist

gen-pdf:
	npm run build
	npm run generate-pdf
