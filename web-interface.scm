(define-module (web-interface)
  #:use-module (web server)
  #:use-module (web request)
  #:use-module (web response)
  #:use-module (web uri)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 match)
  #:use-module (rnrs bytevectors)
  #:use-module (rnrs io ports)
  #:use-module (srfi srfi-1)
  #:use-module (sxml simple)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (json)
  #:use-module (www util)
  #:use-module (www config)
  #:use-module (www pages)
  #:use-module (www pages error)
  #:use-module (www pages package)
  #:use-module (www pages welcome)

  #:export (run-web-interface))


;; ----------------------------------------------------------------------------
;; HANDLERS
;; ----------------------------------------------------------------------------
;;
;; The way a request is handled varies upon the nature of the request.  It can
;; be as simple as serving a pre-existing file, or as complex as finding a
;; Scheme module to use for handling the request.
;;
;; In this section, the different handlers are implemented.
;;

(define (request-packages-json-handler)
  (let ((all-packages (fold-packages cons '()))
        (package->json (lambda (package)
                         (json (object
                                ("name"     ,(package-name package))
                                ("version"  ,(package-version package))
                                ("synopsis" ,(package-synopsis package))
                                ("homepage" ,(package-home-page package)))))))
    (values '((content-type . (application/javascript)))
            (with-output-to-string
              (lambda _
                (scm->json
                 (map package->json
                      (delete
                       #f
                       (map (lambda (item)
                              (cond
                               ;; Blacklist the games..
                               ((string= (package-name item) "cataclysm-dda") #f)
                               ((string= (package-name item) "freedoom") #f)
                               ((string= (package-name item) "gnubg") #f)
                               ((string= (package-name item) "gnubik") #f)
                               ((string= (package-name item) "gnushogi") #f)
                               ((string= (package-name item) "prboom-plus") #f)
                               ((string= (package-name item) "retux") #f)
                               ((string= (package-name item) "xshogi") #f)
                               ((string= (package-name item) "abbaye") #f)
                               ((string= (package-name item) "angband") #f)
                               ((string= (package-name item) "pingus") #f)
                               ((string= (package-name item) "talkfilters") #f)
                               ((string= (package-name item) "cmatrix") #f)
                               ((string= (package-name item) "chess") #f)
                               ((string= (package-name item) "freedink-engine") #f)
                               ((string= (package-name item) "freedink-data") #f)
                               ((string= (package-name item) "freedink") #f)
                               ((string= (package-name item) "xboard") #f)
                               ((string= (package-name item) "xboing") #f)
                               ((string= (package-name item) "gtypist") #f)
                               ((string= (package-name item) "irrlicht") #f)
                               ((string= (package-name item) "mars") #f)
                               ((string= (package-name item) "minetest-data") #f)
                               ((string= (package-name item) "minetest") #f)
                               ((string= (package-name item) "glkterm") #f)
                               ((string= (package-name item) "glulxe") #f)
                               ((string= (package-name item) "fizmo") #f)
                               ((string= (package-name item) "retroarch") #f)
                               ((string= (package-name item) "gnugo") #f)
                               ((string= (package-name item) "extremetuxracer") #f)
                               ((string= (package-name item) "supertuxkart") #f)
                               ((string= (package-name item) "gnujump") #f)
                               ((string= (package-name item) "wesnoth") #f)
                               ((string= (package-name item) "dosbox") #f)
                               ((string= (package-name item) "gamine") #f)
                               ((string= (package-name item) "raincat") #f)
                               ((string= (package-name item) "manaplus") #f)
                               ((string= (package-name item) "mupen64plus-core") #f)
                               ((string= (package-name item) "mupen64plus-audio-sdl") #f)
                               ((string= (package-name item) "mupen64plus-input-sdl") #f)
                               ((string= (package-name item) "mupen64plus-rsp-hle") #f)
                               ((string= (package-name item) "mupen64plus-rsp-z64") #f)
                               ((string= (package-name item) "mupen64plus-video-arachnoid") #f)
                               ((string= (package-name item) "mupen64plus-video-glide64") #f)
                               ((string= (package-name item) "mupen64plus-video-glide64mk2") #f)
                               ((string= (package-name item) "mupen64plus-video-rice") #f)
                               ((string= (package-name item) "mupen64plus-video-z64") #f)
                               ((string= (package-name item) "mupen64plus-ui-console") #f)
                               ((string= (package-name item) "nestopia-ue") #f)
                               ((string= (package-name item) "emulation-station") #f)
                               ((string= (package-name item) "openttd-engine") #f)
                               ((string= (package-name item) "openttd-opengfx") #f)
                               ((string= (package-name item) "openttd") #f)
                               ((string= (package-name item) "pinball") #f)
                               ((string= (package-name item) "pioneers") #f)
                               ((string= (package-name item) "desmume") #f)
                               ((string= (package-name item) "einstein") #f)
                               ((string= (package-name item) "powwow") #f)
                               ((string= (package-name item) "red-eclipse") #f)
                               ((string= (package-name item) "higan") #f)
                               ((string= (package-name item) "grue-hunter") #f)
                               ((string= (package-name item) "lierolibre") #f)
                               ((string= (package-name item) "warzone2100") #f)
                               ((string= (package-name item) "starfighter") #f)
                               ((string= (package-name item) "chromium-bsu") #f)
                               ((string= (package-name item) "tuxpaint") #f)
                               ((string= (package-name item) "tuxpaint-stamps") #f)
                               ((string= (package-name item) "tuxpaint-config") #f)
                               ((string= (package-name item) "supertux") #f)
                               ((string= (package-name item) "tintin++") #f)
                               ((string= (package-name item) "laby") #f)
                               ((string= (package-name item) "bambam") #f)
                               ((string= (package-name item) "mrrescue") #f)
                               ((string= (package-name item) "hyperrogue") #f)
                               ((string= (package-name item) "kobodeluxe") #f)
                               ((string= (package-name item) "freeciv") #f)
                               ((string= (package-name item) "no-more-secrets") #f)
                               ((string= (package-name item) "megaglest-data") #f)
                               ((string= (package-name item) "megaglest") #f)
                               ((string= (package-name item) "freegish") #f)
                               ((string= (package-name item) "cdogs-sdl") #f)
                               ((string= (package-name item) "kiki") #f)
                               ((string= (package-name item) "teeworlds") #f)
                               ((string= (package-name item) "enigma") #f)
                               ((string= (package-name item) "fillets-ng") #f)
                               ((string= (package-name item) "crawl") #f)
                               ((string= (package-name item) "crawl-tiles") #f)
                               ((string= (package-name item) "lugaru") #f)
                               ((string= (package-name item) "0ad-data") #f)
                               ((string= (package-name item) "0ad") #f)
                               ((string= (package-name item) "open-adventure") #f)
                               ((string= (package-name item) "aisleriot") #f)
                               (else item)))
                            all-packages)))))))))

(define (request-file-handler path)
  "This handler takes data from a file and sends that as a response."

  (define (response-content-type path)
    "This function returns the content type of a file based on its extension."
    (let ((extension (substring path (1+ (string-rindex path #\.)))))
      (cond [(string= extension "css")  '(text/css)]
            [(string= extension "js")   '(application/javascript)]
            [(string= extension "json") '(application/javascript)]
            [(string= extension "html") '(text/html)]
            [(string= extension "png")  '(image/png)]
            [(string= extension "svg")  '(image/svg+xml)]
            [(string= extension "ico")  '(image/x-icon)]
            [(string= extension "pdf")  '(application/pdf)]
            [(string= extension "ttf")  '(application/font-sfnt)]
            [(#t '(text/plain))])))

  (let ((full-path (string-append %www-root "/" path)))
    (if (not (file-exists? full-path))
        (values '((content-type . (text/html)))
                (with-output-to-string (lambda _ (sxml->xml (page-error-404 path)))))
        ;; Do not handle files larger than %maximum-file-size.
        ;; Please increase the file size if your server can handle it.
        (let ((file-stat (stat full-path)))
          (if (> (stat:size file-stat) %www-max-file-size)
              (values '((content-type . (text/html)))
                      (with-output-to-string 
                        (lambda _ (sxml->xml (page-error-filesize path)))))
              (values `((content-type . ,(response-content-type full-path)))
                      (with-input-from-file full-path
                        (lambda _
                          (get-bytevector-all (current-input-port))))))))))

(define (request-package-handler request-path)
  (values '((content-type . (text/html)))
          (call-with-output-string
            (lambda (port)
              (sxml->xml (page-package request-path) port)))))

(define (request-scheme-page-handler request request-body request-path)

  (define (module-path prefix elements)
    "Returns the module path so it can be loaded."
    (if (> (length elements) 1)
        (module-path
         (append prefix (list (string->symbol (car elements))))
         (cdr elements))
        (append prefix (list (string->symbol (car elements))))))
  (values '((content-type . (text/html)))
          (call-with-output-string
            (lambda (port)
              (set-port-encoding! port "utf8")
              (format port "<!DOCTYPE html>~%")
              (if (< (string-length request-path) 2)
                  (sxml->xml (page-welcome "/") port)
                  (let* ((function-symbol (string->symbol
                                           (string-map
                                            (lambda (x)
                                              (if (eq? x #\/) #\- x))
                                            (substring request-path 1))))
                         (module (resolve-module
                                  (module-path
                                   '(www pages)
                                   (string-split (substring request-path 1) #\/))
                                  #:ensure #f))
                         (page-symbol (symbol-append 'page- function-symbol)))
                    (if module
                        (let ((display-function
                               (module-ref module page-symbol)))
                          (if (eq? (request-method request) 'POST)
                              (sxml->xml (display-function
                                          request-path
                                          #:post-data
                                          (utf8->string
                                           request-body)) port)
                              (sxml->xml (display-function request-path) port)))
                        (sxml->xml (page-error-404 request-path) port))))))))


;; ----------------------------------------------------------------------------
;; ROUTING & HANDLERS
;; ----------------------------------------------------------------------------
;;
;; Requests can have different handlers.
;; * Static objects (images, stylesheet, javascript files) have their own
;;   handler.
;; * Package pages are generated dynamically, so they have their own handler.
;; * The 'regular' Scheme pages have their own handler that resolves the
;;   module dynamically.
;;
;; Feel free to add your own handler whenever that is necessary.
;;
;; ----------------------------------------------------------------------------
(define (request-handler request request-body)
  (let ((request-path (uri-path (request-uri request))))
    (format #t "~a ~a~%" (request-method request) request-path)
    (cond
     ((string= request-path "/packages.json")
      (request-packages-json-handler))
     ((and (> (string-length request-path) 7)
           (string= (string-take request-path 8) "/static/"))
      (request-file-handler request-path))
     ((and (> (string-length request-path) 8)
           (string= (string-take request-path 9) "/package/"))
      (request-package-handler request-path))
     (else
      (request-scheme-page-handler request request-body request-path)))))


;; ----------------------------------------------------------------------------
;; RUNNER
;; ----------------------------------------------------------------------------
;;
;; This code runs the web server.

(define (run-web-interface)
  (run-server request-handler 'http
              `(#:port ,%www-listen-port
                #:addr ,INADDR_ANY)))

(run-web-interface)
