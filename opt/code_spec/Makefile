all : pdf docx html

pdf : Readme.md
	pandoc Readme.md -o Readme.pdf

doc : docx
docx : Readme.md
	pandoc Readme.md -o Readme.docx

html : Readme.md
	pandoc Readme.md -o Readme.html
