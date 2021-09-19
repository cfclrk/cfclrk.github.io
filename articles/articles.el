;;; articles.el -- My articles  -*- lexical-binding: t; -*-

;;; Commentary:

;; Publish org documents to HTML.

;;; Code:

(require 'site)
(require 'ox-html)

(defconst articles/project-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(defconst articles/org-project-articles
  `("articles"
    :recursive t
    :base-directory
    ,(expand-file-name "org" articles/project-directory)
    :publishing-directory
    ,(expand-file-name "articles" site/publishing-directory)
    :publishing-function site/org-html-publish-to-html
    :exclude "setup\\.org"
    :auto-sitemap t
    :sitemap-title "Articles"
    :html-head-include-scripts nil
    :html-head-include-default-style nil
    :with-creator nil
    :with-author nil
    :with-timestamps nil
    :section-numbers nil
    :html-preamble site/site-preamble
    :html-self-link-headlines t
    :html-head
    "<link rel=\"stylesheet\" type=\"text/css\" href=\"/static/main.css\" />"))

(provide 'articles)
;;; articles.el ends here
