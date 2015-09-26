-- Description of the assignment can be found here: http://www.cs.rpi.edu/academics/courses/fall15/proglang/pa1/pa1.html

import PA1Helper

-- Haskell representation of lambda expression
-- In Lambda Lexp Lexp, the first Lexp should always be Atom String
-- data Lexp = Atom String | Lambda Lexp Lexp | Apply Lexp  Lexp 

-- Given a filename and function for reducing lambda expressions,
-- reduce all valid lambda expressions in the file and output results.
-- runProgram :: String -> (Lexp -> Lexp) -> IO()

-- This is the identity function for the Lexp datatype, which is
-- used to illustrate pattern matching with the datatype. "_" was
-- used since I did not need to use bound variable. For your code,
-- however, you can replace "_" with an actual variable name so you
-- can use the bound variable. The "@" allows you to retain a variable
-- that represents the entire structure, while pattern matching on
-- components of the structure.

id' :: Lexp -> Lexp
id' v@(Atom _) = v
id' lexp@(Lambda (Atom _) _) = lexp
id' lexp@(Apply _ _) = lexp

id1 :: Lexp -> Lexp
--id1 lexp = etaConvert (betaReduce lexp)
--id1 lexp = (betaReduce lexp)
id1 lexp = etaConvert (betaReduce lexp)

id2 :: Lexp -> Lexp
id2 lexp =  (id1 lexp)

alpha :: Lexp -> Lexp
alpha v@(Atom x) = v
alpha lexp@(Lambda (Atom x) expr) = lexp
alpha lexp@(Apply expr1 expr2) = lexp

--alpha lexp = frt (alpha1 lexp counter)

-- alpha: function that takes an expression, a count integer, and output (expr, count)
alpha1 :: Lexp -> Int -> (Lexp, Int)
alpha1 v@(Atom x) counter = (v, counter)

--alpha1 lexp@(Lambda (Atom x) exp) counter = ...
--alpha1 lexp@(Apply exp1 exp2) counter = ...

etaConvert :: Lexp ->  Lexp
etaConvert (Atom v) = Atom v
etaConvert (Apply x y) = Apply (etaConvert x) (etaConvert y)
etaConvert lexp@(Lambda x (Apply e m))                                                                    
  | (not (x `elem` (freeVars e))) && (x == m) = e
  | (not (x `elem` (freeVars m))) && (x == e) = m
  | otherwise = lexp
etaConvert (Lambda x e) =  (Lambda x (etaConvert e))                                                             
--etaConvert lexp =                                                          


-- betaReduce: function to apply beta-reduction to an expression
betaReduce :: Lexp -> Lexp
betaReduce v@(Atom _) = v
betaReduce lexp@(Lambda (Atom x) expr) = (Lambda (Atom x) (betaReduce expr))
--betaReduce lexp@(Apply (Lambda x expr1) expr2) 
--  | x == expr1 = expr2
--  | otherwise = replace x expr2 (betaReduce expr1)
--betaReduce lexp@(Apply expr1 expr2) = (Apply (betaReduce expr1) (betaReduce expr2))
betaReduce lexp@(Apply expr1 expr2) = case expr4 of 
	(Lambda (Atom x) expr) -> betaReduce (replace (Atom x) expr3 expr)
	otherwise -> (Apply expr4 expr3)
	where 	expr5 = betaReduce expr1
          	expr3 = betaReduce expr2
          	expr4 = alphaRename expr5 ((allVars expr5) ++ (freeVars expr3))


-- replace: helper function to replace all appearances of arg in expr with value
replace :: Lexp -> Lexp -> Lexp -> Lexp
replace (Atom arg) value expr@(Atom e) 
  | e == arg = value
  | otherwise = Atom e
replace (Atom arg) value expr@(Lambda (Atom x) e) = Lambda (Atom x) (replace (Atom arg) value e)
replace (Atom arg) value expr@(Apply e1 e2) = Apply (replace (Atom arg) value e1) (replace (Atom arg) value e2)
-- replace done



-- alphaRename: function to apply alphaRename to an expression with an avoiding list
alphaRename :: Lexp -> [Lexp] -> Lexp
alphaRename v@(Atom x) _ = v
alphaRename lexp@(Apply expr1 expr2) _ = (Apply expr1 expr2)
alphaRename lexp@(Lambda (Atom x) expr) avoidList = 
    let
	    x1 = findName (Atom x) avoidList 
    in
        Lambda x1 (alphaRename (replace (Atom x) x1 expr) (avoidList ++ [x1]))
-- alphaRename KINDA done???

-- findName: helper function for alphaRename
findName :: Lexp -> [Lexp] -> Lexp
findName (Atom x) list
  | not ((Atom x) `elem` list) = (Atom x)
  | otherwise =  findName (Atom (x ++ "'")) list
-- find name KINDA done???

-- freeVars: helper function to get all free variables in an expression
freeVars :: Lexp -> [Lexp]
freeVars x@(Atom _) = [x]
freeVars lexp@(Lambda (Atom x) expr) = (freeVars expr) `minus` (Atom x)
freeVars lexp@(Apply expr1 expr2) = (freeVars expr1) ++ (freeVars expr2)

-- allVars: helper function to get all variables in an expression
allVars :: Lexp -> [Lexp]
allVars v@(Atom _) = [v]
allVars lexp@(Lambda x expr) = [x] ++ (allVars expr)
allVars lexp@(Apply expr1 expr2) = (allVars expr1) ++ (allVars expr2)
-- allVars done

-- minus: helper function to take an element a from list [a], a belongs to class Eq
minus :: (Eq a) => [a] -> a -> [a]
minus [] _ = []
minus list@(listHead:listTail) x
  | x == listHead = (minus listTail x)
  | otherwise = (listHead:(minus listTail x))
-- minus done

-- Entry point of program
main = do
    putStrLn "Please enter a filename containing lambda expressions:"
    fileName <- getLine
    -- id' simply returns its input, so runProgram will result
    -- in printing each lambda expression twice. 
    putStrLn "\nThe reduction results are:\n"
    runProgram fileName id2
