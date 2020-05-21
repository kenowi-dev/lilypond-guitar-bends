\version "2.20.0"

\include "guitar-string-bending/module.ily"

#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1) (or (eq? n 6) (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1) (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (ly:make-pitch o n (/ a 4))))

#(define (naturalize music)
   (let ((es (ly:music-property music 'elements))
         (e (ly:music-property music 'element))
         (p (ly:music-property music 'pitch)))
     (if (pair? es)
         (ly:music-set-property!
          music 'elements
          (map (lambda (x) (naturalize x)) es)))
     (if (ly:music? e)
         (ly:music-set-property!
          music 'element
          (naturalize e)))
     (if (ly:pitch? p)
         (begin
           (set! p (naturalize-pitch p))
           (ly:music-set-property! music 'pitch p)))
     music))

% Music Functions

slideIn = #(define-music-function (note delta) (ly:music? ly:pitch?)
                (let ((copy (ly:music-deep-copy note))
                      (original (ly:music-deep-copy note))
                      (pitch (ly:music-property note 'pitch)))
                     (set! (ly:music-property note 'pitch) 
                           (ly:make-pitch -1
                                          (ly:pitch-notename pitch) 
                                          (ly:pitch-alteration pitch)))                    
                     #{                        
                        \once\override Glissando.minimum-length = #4
                        \once\override Glissando.springs-and-rods = #ly:spanner::set-spacing-rods
                        \hideNotes\grace{ #(ly:music-transpose copy delta)  \glissando } \unHideNotes #note 
                     #}))

%\grace{ \transpose c #delta { \relative #pitch #copy } \glissando } \unHideNotes \transpose c c { \relative #pitch #note }

slideInUp = #(define-music-function (note) (ly:music?) 
                (slideIn note #{ as #}))

slideInDown = #(define-music-function (note) (ly:music?) 
                (slideIn note #{ e' #}))


slideOut = #(define-music-function (note) (ly:music?)
           (let ((copy (ly:music-deep-copy note)))
             (set! (ly:music-property note 'articulations)
                   (cons (make-music 'GlissandoEvent)
                         (ly:music-property note 'articulations))) #{
               \once\override Glissando.minimum-length = #5
               \once\override Glissando.springs-and-rods = #ly:spanner::set-spacing-rods
               \afterGrace #note { \hideNotes \transpose c e { #copy } \unHideNotes }
           #}))

bend = #(define-music-function (parser location amount note)
              (rational? ly:music?)
              (let* ((pitch (ly:music-property note 'pitch))
                     (bendPitch (naturalize-pitch (ly:make-pitch (ly:pitch-octave pitch)
                                          (ly:pitch-notename pitch)
                                          (- (ly:pitch-alteration pitch) amount))))
                     (bended (make-music 'NoteEvent
                                         'duration (ly:make-duration 3 0 1/1)
                                         'pitch bendPitch)))
                #{
                  \bendOn
                  \acciaccatura #bended \bendOff #note
                #}))

bendHalf = #(define-music-function (parser location note)
              (ly:music?)
              (bend 1/2 note))

bendFull = #(define-music-function (parser location note)
              (ly:music?)
              (bend 1 note))


bendNext = {
  \once \override Voice.Tie.stencil = #slur::draw-pointed-slur
  \once \override Voice.Slur.stencil = #slur::draw-pointed-slur
}
