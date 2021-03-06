;;; Copyright © 2017  Roel Janssen <roel@gnu.org>
;;; Copyright © 2017  Ricardo Wurmus <rekado@elephly.net>
;;;
;;; This program is free software: you can redistribute it and/or
;;; modify it under the terms of the GNU Affero General Public License
;;; as published by the Free Software Foundation, either version 3 of
;;; the License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; Affero General Public License for more details.
;;;
;;; You should have received a copy of the GNU Affero General Public
;;; License along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

(define-module (www pages welcome)
  #:use-module (www pages)
  #:export (page-welcome))

(define (page-welcome request-path)
  (page-root-template "Search" request-path
   `((h2 "Find software packages")

     (form
      (input (@ (type "search")
                (id "search-field")
                (class "search-field")
                (aria-controls "packages-table")
                (placeholder "Search"))))
     (hr)
     (div (@ (id "stand-by")) (p "Please wait for the package data to load..."))
     (div (@ (id "packages-table-wrapper"))
          (table (@ (id "packages-table")
                    (class "display"))
                 (thead
                  (tr
                   (th "Name")
                   (th "Version")
                   (th "Synopsis")
                   (th "Module")
                   (th (@ (style "width: 250pt")) "Homepage")))))
     (script (@ (type "text/javascript")
                (src "/static/hpcguix-web.min.js")) ""))
   #:dependencies '(datatables)))
