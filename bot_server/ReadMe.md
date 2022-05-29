### Request Bodies

#### Ways to initiate chat
```
{
    "request": {
        "code": "dayFirstLaunch",
        "version":"1.0.0"
    }
}
```

#### User wants to chat with bot
```
{
    "request": {
        "code": "typedText",
        "version":"1.0.0",
        "data": {
            "query": "want to enter my weight on 26th may"
        }
    }
}
```
#### Quick Action
```
{
    "request": {
        "code": "quickAction",
        "version":"1.0.0",
        "data": {
            "botTaskId": 200
        }
    }
}
```
-----
### Restart Server
```
sudo kill -9 `sudo lsof -t -i:3000`
```
----
### Amazon Comprehend Resonses
#### Key Phrases Analysis
```
{
    "KeyPhrases": [
        {
            "Score": 0.9999569654464722,
            "Text": "my weight",
            "BeginOffset": 14,
            "EndOffset": 23
        },
        {
            "Score": 0.988757312297821,
            "Text": "26th",
            "BeginOffset": 27,
            "EndOffset": 31
        }
    ]
}
```
#### Key Entries Analysis
```
{
    "Entities": [
        {
            "Score": 0.9894523620605469,
            "Type": "DATE",
            "Text": "26th may",
            "BeginOffset": 27,
            "EndOffset": 35
        }
    ]
}
```
#### Key Syntax Token Analysis
```
{
    "SyntaxTokens": [
        {
            "TokenId": 1,
            "Text": "want",
            "BeginOffset": 0,
            "EndOffset": 4,
            "PartOfSpeech": {
                "Tag": "VERB",
                "Score": 0.995025634765625
            }
        },
        {
            "TokenId": 2,
            "Text": "to",
            "BeginOffset": 5,
            "EndOffset": 7,
            "PartOfSpeech": {
                "Tag": "PART",
                "Score": 0.9999856948852539
            }
        },
        {
            "TokenId": 3,
            "Text": "enter",
            "BeginOffset": 8,
            "EndOffset": 13,
            "PartOfSpeech": {
                "Tag": "VERB",
                "Score": 0.9999977350234985
            }
        },
        {
            "TokenId": 4,
            "Text": "my",
            "BeginOffset": 14,
            "EndOffset": 16,
            "PartOfSpeech": {
                "Tag": "PRON",
                "Score": 0.9999768733978271
            }
        },
        {
            "TokenId": 5,
            "Text": "weight",
            "BeginOffset": 17,
            "EndOffset": 23,
            "PartOfSpeech": {
                "Tag": "NOUN",
                "Score": 0.9998605251312256
            }
        },
        {
            "TokenId": 6,
            "Text": "on",
            "BeginOffset": 24,
            "EndOffset": 26,
            "PartOfSpeech": {
                "Tag": "ADP",
                "Score": 0.9905756711959839
            }
        },
        {
            "TokenId": 7,
            "Text": "26th",
            "BeginOffset": 27,
            "EndOffset": 31,
            "PartOfSpeech": {
                "Tag": "NOUN",
                "Score": 0.6818108558654785
            }
        },
        {
            "TokenId": 8,
            "Text": "may",
            "BeginOffset": 32,
            "EndOffset": 35,
            "PartOfSpeech": {
                "Tag": "AUX",
                "Score": 0.9970732927322388
            }
        }
    ]
}
```