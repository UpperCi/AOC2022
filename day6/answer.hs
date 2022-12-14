module Main where
import System.IO  

charIn :: Char -> [Char] -> Bool
charIn c src = length (filter (\n -> n == c) src) > 0

-- check if string has only unique characters
unique :: Char -> [Char] -> Bool
unique c [] = True
unique c src = if charIn c src
	then False
	else unique (head src) (tail src)

-- get index of first four unique characters
totext :: [Char] -> Int -> Int -> Int
totext s i step = if unique (head s) (tail (take step s))
	then i
	else totext (tail s) (i + 1) step

main = do
	contents <- readFile "packet.txt"
	print $ (totext contents (0 + 4) 4)
	print $ (totext contents (0 + 14) 14)
	
