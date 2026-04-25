module ChromaEVAL where

import ChromaAST
import Main (RGB, Value)
import Graphics.Win32 (rgb)

lookupEnv :: Var -> Env -> Value

{- Empty Enviroment -}
lookupEnv name [] =
    error("!!VARIABLE NOT FOUND!!: " ++ name)

{- Enviroment has variables -}
lookupEnv name ((var, val):rest)
    | name == var = val
    | otherwise = lookupEnv name rest

{- Update Variables -}
updateEnv:: Var -> Value -> Env -> Env
updateEnv name newVal [] =
    [(name, newVal)]

updateEnv name newVal ((var, val):rest)
    | name == var = (var, newVal) : rest
    | otherwise = (var, val): updateEnv name newVal rest

{- Int Eval -}
evalInt:: Env -> IntExpr -> Int
evalInt env (IntLit n) =
    n

evalInt env (IntVar name) = 
    case lookupEnv name env of
        IntVal n -> n
        other -> error ("!!EXPECTED:: INT!! : " ++ show other)

{- HEX to Int Conversion -}
hexCharToInt :: HexChar -> Int
hexCharToInt Zero = 0
hexCharToInt One = 1
hexCharToInt Two = 2
hexCharToInt Three = 3
hexCharToInt Four = 4
hexCharToInt Five = 5
hexCharToInt Six = 6
hexCharToInt Seven = 7
hexCharToInt Eight = 8
hexCharToInt Nine = 9
hexCharToInt LA = 10
hexCharToInt LB = 11
hexCharToInt LC = 12
hexCharToInt LD = 13
hexCharToInt LE = 14
hexCharToInt LF = 15
hexCharToInt UA = 10
hexCharToInt UB = 11
hexCharToInt UC = 12
hexCharToInt UD = 13
hexCharToInt UE = 14
hexCharToInt UF = 15

hexValueToInt :: HexValue -> Int
hexValueToInt (first, second) =
    hexCharToInt first * 16 + hexCharToInt second

{- HEX to RGB -}
hexToRGB :: HEX -> RGB
hexToRGB (HEX r g b) =
    RGB (hexValueToInt r) (hexValueToInt g) (hexValueToInt b)

colorToRGB :: Value -> RGB
colorToRGB (RGBVal rgb) = 
    rgb

colorToRGB (HexVal hex) =
    hexToRGB hex

colorToRGB other = 
    error ("!!EXPECTED VALUE:: RGB or HEX!! : " ++ show other)

clamp:: Int -> Int
clamp n
    | n < 0 = 0
    | n > 255 = 255
    | otherwise = n

{- Mix RGB Values  -}
mixRGB :: RGB -> RGB -> RGB
mixRGB (RGB r1 g1 b1) (RGB r2 g2 b2) =
    RGB ((r1 + r2) `div` 2)
        ((g1 + g2) `div` 2)
        ((b1 + b2) `div` 2)

{-Shade RGB Values (darken) -}
shadeRGB :: RGB -> Int -> RGB
shadeRGB (RGB r g b) amout =
    RGB (clamp (r - amount))
        (clamp (g - amount))
        (clamp (b - amount))

{-Tint RGB Values (lighten) -}
tintRGB :: RGB -> Int -> RGB
tintRGB (RGB r g b) amount =
    RGB (clamp (r + amount))
        (clamp (g + amount))
        (clamp (b + amount))

{- Color Expressions -}
evalColor :: Env -> ColorExpr -> Value

evalColor env (RGBExpr rgb) =
    RGBVal rgb

evalColor env (HEXExpr hex) = 
    HexVal hex

evalColor env (ColorVar name) = 
    lookupEnv name env

evalColor env (Mix c1 c2) =
    RGBVal (mixRGB rgb1 rgb2)
    where
        rgb1 = colortoRGB (evalColor env c1)
        rgb2 = colorToRGB (evalColor env c2)

evalColor env (Shade color amount) = 
    RGBVal (shadeRGB rgb n)
    where
        rgb = colorToRGB (evalColor env color)
        n = evalInt env amount

evalColor env (Tint color amount) = 
    RGBVal (tintRGB rgb n)
    where
        rgb = colorToRGB (evalColor env color)
        n = evalInt env amount


