Input: {"method": "isPrime", "number": 199}


Stack based ?

we start with an empty stack

if the stack is empty we push the current char to the stack and continue
else we peek & check if the current char is allowed:
    -> skip
    -> push
    -> pop 

what cases trigger which op { skip | push | pop } ?


State machines ?

        WS
SkipWS ----> SkipWS | WS = { ' ', '\t', '\r', '\n' }

* consider an implicit call to SkipWS before (OR after?) every transition listed below

JToken = JObject | JString | JNumber (only these are required for now)

JObject:
    LCurly -> JObject.Pair -> (Comma -> JObject.Pair)* -> RCurly

JObject.Pair: 
    JString -> Colon -> JToken

JString:
    Quote -> Any -> Quote (only if prev != '\')

JNumber:
    ?(Minus) -> Digit -> ?(Dot) -> Digit



