import Numeric
import Data.List

twosoliton :: Double -> Double -> Double
twosoliton t x = (3 + 4 * cosh (2 * x - 8 * t) + cosh (4*x - 64*t)) / ((3 * cosh(x - 28*t) + cosh (3*x - 36*t))^2)

writeData :: String -> [String] -> [[Double]] -> IO()
writeData file header dat = writeFile file $
    unwords header ++ "\n" ++ (unlines $ map (unwords . map show) dat)

main = writeData "solitons.csv" ["x 0 1 2 3 4 5 6"] $ transpose $
           xvals:(map f times)
      where f t = map (twosoliton t) xvals
            times = [-1, -0.5, -0.15, 0, 0.15, 0.5, 1]
            xvals = [-20,-19.95..20]
