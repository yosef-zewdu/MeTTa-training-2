;; Tasks 

;;  1. extract the last element -- e.g., (:: 1 (:: 2 (:: 3 (:: 4 ())))) the last element would be 4

;; if the tail is () we return the head  (:: 4 ()) -> (4)
;; if not we pass the tail to the fuction to call again till it reaches the last element 
;; $x - head of list 
;; $y - tail of the list

(= (last (:: $x $y))
    ( if (== $y ())  $x
        (last  $y) )    
)  

;! (last (:: 1 (:: 2 (:: 3 (:: 4 ()))))) ;; output --> 4

;! (last (:: 1  (:: 10 (:: 2 (:: 6 (:: 5 ())))))) ;; Expected output --> 5

;; -------------------------------------------------

;;  2. append one more element to the list at the begining -- e. g., adding 0 to the list (:: 1 (:: 2 (:: 3 (:: 4 ())))) --> (:: 0(:: 1 (:: 2 (:: 3 (:: 4 ())))))

;; the append-b function appends an element at the begining of the list 
;; arguments are a list and the element

(= (append-b  $list $element ) (:: $element  $list ))

;! (append-b (:: 1 (:: 2 (:: 3 (:: 4 ())))) 0)     ;; Expected output --> [(:: 7 (:: 1 (:: 2 (:: 3 (:: 4 ())))))]
;! (append-b () 3)                                 ;; Expected output --> [(:: 3 ())]

;; -------------------------------------------------

;;  3. append one more element to the list at the end -- e. g., adding 5 to the list (:: 1 (:: 2 (:: 3 (:: 4 ())))) --> (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 ())))))

;; the append-e function appends an element at the end of the list 
;; arguments are a list and the element

;; BaseCase -- if the list is empty append the element
(= (append-e () $element) (:: $element ()))

(= (append-e (:: $x $xs) $element)
     (:: $x (append-e $xs $element))
)

;! (append-e (:: 1 (:: 2 (:: 3 (:: 4 ())))) 5)  ;; Expected output -->  (:: 1 (:: 2 (:: 3 (:: 4 (:: 5 ())))))

;; -------------------------------------------------

;;  4. write a function to find the length without the use of the :: symbol

(= (length-list ()) 0) ;; --- Base case if the list is empty return 0 

(= (length-list (Cons $x $y))
    (+ 1 (length-list $y))
)

;! (length-list (Cons 1 (Cons 2 (Cons 3 (Cons 4 ()))))) ;; Expected output --> 4

;! (length-list (Cons 2 (Cons 3 (Cons 4 ()))))          ;; Expected output --> 3

;; -------------------------------------------------

;;  5. a function to extract all the elements of the above list type into an expresion -- (:: 1 (:: 2 (:: 3 (:: 4 ())))) --> (1 2 3 4)


(= (extract (:: $x $y))
    
   ( if (== $y ()) $x
    
                 
    (cons-atom $x ((extract $y)))     
) 
)  

;! (extract (:: 1 (:: 2 (:: 3 (:: 4 ()))))) ;; Expected output --> (1 2 3 4)

;! (extract (:: 1 (:: 2 (:: 3 (:: 0 ()))))) ;; Expected output --> (1 2 3 0)

;; -------------------------------------------------


;;  6.  finding length of an expression of the form (A B C) -- 3


(= (length-exp $y)
    (if (== $y ()) 0
        (let $tail (cdr-atom $y) 
            ( + 1 (length-exp $tail)))
    )
)

;! (length-exp (A B C ))    ;; Expected output --> 3

;! (length-exp (1 4 6 g))   ;; Expected output --> 4


;; -------------------------------------------------

;;  7.  finding an expression containing sum of two numeric expressions (including length checking conditions -- a plus)

;; function to check the length of the expressions 
(= (length $y)
    (if (== $y ()) 0
        (let $tail (cdr-atom $y) 
            ( + 1 (length $tail))) 
    )
)



(= (sum-exp  $x $y)

(if (and (== $x ()) (== $y ())) () ;; --- BaseCase 

(if  (== (length $x) (length $y))

(let* 
    (
        ($head-1 (car-atom $x))
        ($head-2 (car-atom $y))
        ($tail-1 (cdr-atom $x))
        ($tail-2 (cdr-atom $y))
        ($head  (+ $head-1 $head-2))
        ($rest  (sum-exp $tail-1 $tail-2))
          
    )
    (cons-atom $head $rest)
)
    (
        Error: Number of elements mismatch. Check if the 2 expressions element are equal
    )
)
)
)

;! (sum-exp (1 2 3) (4 5 6))            ;; Expected output --> (5 7 9)
;! (sum-exp (1 2 4 3) (4 5 6))          ;; Expected output --> Error message 
;! (sum-exp () (4 5 6))   ;; (5 7 9)    ;; Expected output --> Error message 
;! (sum-exp () ())   ;; (5 7 9)      ;; ;; Expected output --> ()

;; -------------------------------------------------

;;  8.  select by index function , e.g., in (1 3 4) (funct (1 3 4) 0) -- 1


;; 'length' function is found in task-7
;; the function checks if indext is beyond the range of the expression by checking the if the index is less than length of the expression
;; index function takes arguments: the expresion, $exp and the index, $i
;; the function recursively checks by removing the first element until the index matches

(= (index $exp $i)
    (if (> $i (length $exp)) 
        Error:index-out-of-range
        (if (== $i 0)
           (car-atom $exp)
           (index (cdr-atom $exp) (- $i 1))
        )
    )
)

;! (index (1 3 7 6 2 4) 0)
;! (index (1 3 7 6 2 4) 3)
;! (index (1 3  7 6 7 4) 5)
;! (index (1 3 7 6 2 4) 7)

;; -------------------------------------------------

;;  9.  slicing an expression by index


;; slice function has arguments: expression, start and end 
;; start index is included but end index is not 
;; if expression is empty or the end index is less than 1 it will return ()

(= (slice $exp $start $end)
   (if (or (== $exp ()) (< $end 1))
       ()                                           ;; base case: nothing to return
       (if (> $start 0)
           (slice (cdr-atom $exp) (- $start 1) (- $end 1))  ;; drop head until start reaches 0
           ( (car-atom $exp) (slice (cdr-atom $exp) 0 (- $end 1))) 
       )
   )
)


;!  (slice (1 3 7 4) 1 3)  ;; Expected output: (3 7)
;!  (slice (1 3 7 4) 0 2)  ;; Expected output: (1 3)
;!  (slice (1 3 7 4) 2 4)  ;; Expected output: (7 4)
;!  (slice (1 3 7 4) 3 5)  ;; Expected output: (4)
;!  (slice (1 3 7 4) 4 6)  ;; Expected output: ()

;; -------------------------------------------------

;;  10. Reconstruct an expression using car-atom, cdr-atom and cons-atom 
;; make use of the println! function to show reconstruction variable outputs

;; eg
; for (B 4 5 3) -- original expression
; B
; 4
; 5
; 3
; (3)
; (5 3)
; (4 5 3)
; (B 4 5 3) -- reconstructed expression


(= (reconstruct $x)
    (if (== $x ())  ; --- base case 
        ()
        (let* ( ($head   (car-atom $x))
                ($tail (cdr-atom $x))
                ($rest (reconstruct $tail))
                ($full (cons-atom $head $tail)))

            ;(println! $head)
            (println! $full))      
    )
)

;! (reconstruct (1 2 3 4))