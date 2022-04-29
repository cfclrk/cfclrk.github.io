;;; site.el -- My website  -*- lexical-binding: t; -*-

;;; Commentary:

;; A few functions required for publishing org files to https://cfclrk.com.

;;; Code:

(require 'ox)
(require 'f)

(defconst site/project-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(defconst site/publishing-directory
  (expand-file-name "~/Projects/cfclrk.com/docs"))

(defun site/site-preamble (project-plist)
  "Return the contents of navbar.html as a string.
PROJECT-PLIST has the full contents of all files and properties
in the project."
  (f-read (expand-file-name "navbar.html" site/project-directory)))

(defun site/compile-scss (project-plist)
  "Compile SCSS to CSS.
PROJECT-PLIST has all project info, but we don't need it."
  (let ((scss-file (expand-file-name "static/main.scss"
                                     site/project-directory))
		(out-file (expand-file-name "static/main.css"
                                    site/project-directory)))
	(call-process "sass" nil nil nil scss-file out-file)))

;;;; HTML Derived Backend
;; -------------------------------------------------------------------

(defun site/org-html-fixed-width (fixed-width _contents _info)
  "Transcode a FIXED-WIDTH element from Org to HTML.
This overrides the `org-html-fixed-width' function in ox-html.el
to add a string #+RESULTS in exported HTML documents
before (some) RESULTS blocks.

CONTENTS is nil. INFO is a plist with contextual information."
  (format "<div class=\"results\">#+RESULTS:</div><pre class=\"example\">\n%s</pre>"
	  (org-html-do-format-code
	   (org-remove-indentation
	    (org-element-property :value fixed-width)))))


(org-export-define-derived-backend 'site/html 'html
  :translate-alist '((fixed-width . site/org-html-fixed-width)))


(defun site/org-html-publish-to-html (plist filename pub-dir)
  "Publish an org file to HTML.

FILENAME is the filename of the Org file to be published.  PLIST
is the property list for the given project.  PUB-DIR is the
publishing directory.

Return output file name."
  (org-publish-org-to 'site/html filename
		      (concat (when (> (length org-html-extension) 0) ".")
			      (or (plist-get plist :html-extension)
				  org-html-extension
				  "html"))
		      plist pub-dir))

;;;; Project alist
;; -------------------------------------------------------------------

(defconst site/org-project-alist
  `(("site-static"
     :recursive t
     :base-directory
     ,(expand-file-name "static" site/project-directory)
     :publishing-directory
     ,(expand-file-name "static" site/publishing-directory)
     :base-extension "png\\|jpg\\|gif\\|pdf\\|css"
     :publishing-function org-publish-attachment
     :preparation-function site/compile-scss)

    ("site-homepage"
     :base-directory ,site/project-directory
     :publishing-directory ,site/publishing-directory
     :publishing-function org-html-publish-to-html
     :base-extension "org"
     :exclude ".*"
     :include ("index.org")
     :html-head-include-scripts nil
     :html-head-include-default-style nil
     :with-creator nil
     :with-author nil
     :section-numbers nil
     :html-preamble site/site-preamble
     :html-self-link-headlines t
     :html-head
     "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/main.css\" />")))

;; Add (or update) the projects in site/org-project-alist
(dolist (project site/org-project-alist)
  (let ((project-name (car project)))
    (setq org-publish-project-alist
          (cons project
                (assoc-delete-all project-name org-publish-project-alist)))))

(provide 'site)
;;; site.el ends here
