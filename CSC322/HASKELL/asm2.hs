--Joshua Pinos
--Dr. Chan
--Csc 322
--February 22, 2015

h3 :: Int -> Integer
h3 0 = 0
h3 n = 2 * h3 (n - 1) + 1

h4 ::Int -> Integer
h4 0 = 0
h4 n =  minimum [2*h4(k)+h3(n-k)|k<-[0..n-1]]


memoized_h4:: Int -> Integer
memoized_h4 = (map lh4 [0 ..]!!)
		where lh4 0 = 0
		      lh4 n = minimum [2*memoized_h4(k)+h3(n-k)|k<-[0..n-1]]

memoized_h5:: Int -> Integer
memoized_h5 = (map lh5 [0 ..]!!)
		where lh5 0 = 0
		      lh5 n = minimum [2*memoized_h5(k)+memoized_h4(n-k)|k<-[0..n-1]]

--Memoized_h4 output for 100 = 172033
--Memoized_h5 output for 64 = 1535
