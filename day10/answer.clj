(ns answer.core
	(:require [clojure.string :as string]))

(declare iter_cmd)

(defn get_x [data]
	(Integer/parseInt (last (first data))))

(defn sum_cmd
	([sum] (sum_cmd sum 20 0))
	([sum tick total] 
		(if (> (count sum) 0)
		(sum_cmd (subvec sum 1) (+ tick 40) (+ total (* (first sum) tick)))
		total)))

(defn next_cycle [each_tick cmd tick x sum]
	(if (> (count cmd) 1)
	(iter_cmd each_tick (subvec cmd 1) (+ tick 1) x sum)
	sum))

(defn print_spr [spr] ; actually crashes
	(if (> (count spr) 0)
		((print (first spr))
		(flush)
		(print_spr (subvec spr 1)))))

(defn iter_spr
	([pos] (iter_spr pos 0 []))
	([pos tick spr]
		(if (> (count pos) 1)
			(if (< (abs (- (mod tick 40) (first pos))) 2)
			(iter_spr (subvec pos 1) (+ tick 1) (conj spr "█"))
			(iter_spr (subvec pos 1) (+ tick 1) (conj spr " ")))
			spr)))

(defn iter_cmd 
	([each_tick cmd] (iter_cmd each_tick cmd 0 1 []))
	([each_tick cmd tick x sum]
		(if (or each_tick (= (mod (+ tick 20) 40) 39))
		(next_cycle each_tick cmd tick (+ x (first cmd)) (conj sum x))
		(next_cycle each_tick cmd tick (+ x (first cmd)) sum))))

(defn parse_data
	([data] (parse_data data []))
	([data cmd]
	(if (> (count data) 0)
		(case (first (first data))
			"addx" (parse_data (subvec data 1) (conj (conj cmd 0) (get_x data)))
			"noop" (parse_data (subvec data 1) (conj cmd 0)))
		cmd)))

(defn main [data] 
	(println (sum_cmd (iter_cmd false (parse_data data))))
	(print_spr (iter_spr (iter_cmd true (parse_data data)))))

(main
	(vec (map
		#(string/split % #" ")
		(string/split (slurp "asm.txt") #"\n"))))
