-- import Data.String (IsString)
-- import Distribution.Simple (VersionInterval)
-- import Distribution.Fields (ParseResult)
-- {- 

-- <prog> -> [<stmt>]

-- <stmt> -> swatch <var> "=" <colorexpr>
--         | <var> "=" <expr>
--         | print <expr>
--         | if "(" <boolexpr> ")" "{" [<stmt>] "}"
--         | if "(" <boolexpr> ")" "{" [<stmt>] "}" else "{" [<stmt>] "}"

-- <expr> -> <colorexpr>
--         | <intexpr>
--         | <boolexpr>

-- <colorexpr> -> mix "(" <colorexpr> "," <colorexpr> ")"
--              | shade "(" <colorexpr> "," <intexpr> ")"
--              | tint "(" <colorexpr> "," <intexpr> ")"
--              | <var>
--              | <rgbval>
--              | <hexval>

-- <intexpr> -> <intval>
--           | <var>

-- <boolexpr> -> <colorexpr> ">" <colorexpr>
--            | <colorexpr> "<" <colorexpr>
--            | <colorexpr> "==" <colorexpr>

-- <value> -> <rgbval>
--          | <intval>
--          | <hexval>

-- <rgbval> -> rgb "(" <intval> "," <intval> "," <intval> ")"

-- <hexval> -> hex "(" <hexpair> "," <hexpair> "," <hexpair> ")"

-- <hexpair> -> <hexnum> <hexnum>

-- <hexnum> -> 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
--           | a | b | c | d | e | f
--           | A | B | C | D | E | F

-- <intval> -> int

-- <env> -> [(<var>, <value>)]

-- -}

-- type Var = String

-- data Program
--     = Program [Stmt]
--     deriving (Show, Eq)

-- data Stmt
--     = Declare Var ColorExpr
--     | Assign Var Expr
--     | Print Expr
--     | If BoolExpr [Stmt] (Maybe [Stmt])
--     deriving (Show, Eq)

-- data Expr
--     = ColorE ColorExpr
--     | IntE IntExpr
--     | BoolE BoolExpr
--     deriving (Show, Eq)

-- data ColorExpr
--     = Mix ColorExpr ColorExpr
--     | Shade ColorExpr IntExpr
--     | Tint ColorExpr IntExpr
--     | ColorVar Var
--     | RGBExpr RGB
--     | HEXExpr HEX
--     deriving (Show, Eq)

-- data IntExpr
--     = IntLit Int
--     | IntVar Var
--     deriving (Show, Eq)

-- data BoolExpr
--     = GreaterColor ColorExpr ColorExpr
--     | LessColor ColorExpr ColorExpr
--     | EqualColor ColorExpr ColorExpr
--     deriving (Show, Eq)

-- data Value
--     = RGBVal RGB
--     | HexVal HEX
--     | IntVal Int
--     deriving (Eq)

-- instance Show Value where
--     show (RGBVal rgb) = show rgb
--     show (HexVal hex) = show hex
--     show (IntVal n) = show n

-- data RGB
--     = RGB Int Int Int
--     deriving (Eq)

-- {- RGB(255, 255, 255) -}
-- instance Show RGB where
--     show(RGB r g b) =
--         "RGB(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ ")"

-- data HexChar = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine | LA | LB | LC | LD | LE | LF | UA | UB | UC | UD | UE | UF
--     deriving Eq

-- instance Show HexChar where
--     show :: HexChar -> String
--     show Zero = "0"
--     show One = "1"
--     show Two = "2"
--     show Three = "3"
--     show Four = "4"
--     show Five = "5"
--     show Six = "6"
--     show Seven = "7"
--     show Eight = "8"
--     show Nine = "9"
--     show LA = "A"
--     show LB = "B"
--     show LC = "C"
--     show LD = "D"
--     show LE = "E"
--     show LF = "F"
--     show UA = "A"
--     show UB = "B"
--     show UC = "C"
--     show UD = "D"
--     show UE = "E"
--     show UF = "F"

-- type HexValue = (HexChar, HexChar)

-- {-AA-}
-- showHexValue:: HexValue -> String
-- showHexValue (first, second) = 
--     show first ++ show second

-- data HEX
--     = HEX HexValue HexValue HexValue
--     deriving (Eq)

-- {- #AAAAAA -}
-- instance Show HEX where
--     show (HEX r g b) = 
--         "#" ++ showHexValue r ++ showHexValue g ++ showHexValue b


-- type Env = [(Var, Value)]


-- lookupEnv :: Var -> Env -> Value

-- {- Empty Enviroment -}
-- lookupEnv name [] =
--     error("!!VARIABLE NOT FOUND!!: " ++ name)

-- {- Enviroment has variables -}
-- lookupEnv name((var, val):rest)
--     | name == var = val
--     | otherwise = lookupEnv name rest

-- {- Update Variables -}
-- updateEnv:: Var -> Value -> Env -> Env
-- updateEnv name newVal [] =
--     [(name, newVal)]

-- updateEnv name newVal((var, val):rest)
--     |name == var = (var, newVal) : rest
--     |otherwise = (var, val): updateEnv name newVal rest

-- {- Int Eval -}
-- evalInt:: Env -> IntExpr -> Int
-- evalInt env (IntLit n) =
--     n

-- evalInt env(IntVar name) = 
--     case lookupEnv name env of
--         IntVal n -> n
--         other -> error ("!!EXPECTED:: INT!! : " ++ show other)

-- {- HEX to Int Conversion -}
-- hexCharToInt :: HexChar -> Int
-- hexCharToInt Zero = 0
-- hexCharToInt One = 1
-- hexCharToInt Two = 2
-- hexCharToInt Three = 3
-- hexCharToInt Four = 4
-- hexCharToInt Five = 5
-- hexCharToInt Six = 6
-- hexCharToInt Seven = 7
-- hexCharToInt Eight = 8
-- hexCharToInt Nine = 9
-- hexCharToInt LA = 10
-- hexCharToInt LB = 11
-- hexCharToInt LC = 12
-- hexCharToInt LD = 13
-- hexCharToInt LE = 14
-- hexCharToInt LF = 15
-- hexCharToInt UA = 10
-- hexCharToInt UB = 11
-- hexCharToInt UC = 12
-- hexCharToInt UD = 13
-- hexCharToInt UE = 14
-- hexCharToInt UF = 15

-- hexValueToInt :: HexValue -> Int
-- hexValueToInt (first, second) =
--     hexCharToInt first * 16 + hexCharToInt second

-- {- HEX to RGB -}
-- hexToRGB :: HEX -> RGB
-- hexToRGB (HEX r g b) =
--     RGB (hexValueToInt r) (hexValueToInt g) (hexValueToInt b)

-- colorToRGB :: Value -> RGB
-- colorToRGB (RGBVal rgb) = 
--     rgb

-- colorToRGB (HexVal hex) =
--     hexToRGB hex

-- colorToRGB other = 
--     error ("!!EXPECTED VALUE:: RGB or HEX!! : " ++ show other)

-- clamp:: Int -> Int
--     clamp n
--     | n < 0 = 0
--     | n > 255 = 255
--     | otherwise = n


 















-- {-   EXAMPLE


-- swatch sunset = rgb(255, 120, 60)
-- swatch ocean = hex(00, 66, CC)
-- level = 20

-- if (sunset > ocean) {
--     swatch result = mix(sunset, ocean)
--     print result
-- } else {
--     print shade(ocean, level)
-- }

-- AST

-- Program
-- [ Declare "sunset" (RGBExpr (RGB 255 120 60))
-- , Declare "ocean" (HEXExpr (HEX "00" "66" "CC"))
-- , Assign "level" (IntE (IntLit 20))
-- , If
--     (GreaterColor (ColorVar "sunset") (ColorVar "ocean"))
--     [ Declare "result"
--         (Mix (ColorVar "sunset") (ColorVar "ocean"))
--     , Print (ColorE (ColorVar "result"))
--     ]
--     (Just
--         [ Print
--             (ColorE
--             (Shade (ColorVar "ocean") (IntVar "level")))
--         ])
-- ]


-- -}


