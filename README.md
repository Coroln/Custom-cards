# Coroln's Custom-cards

These are some Custom Cards me and some friends made. we mad a ton of cards, from support for archtypes that alrady exist to own archtypes and even single cards.

# Everyone is welcome

anyone can make custom cards and if you want to have your custom cards in this repo just make a pull request and we will see what we can do.

the only rules are:
1. the cards shouldn't look like total crap, but they don't need to be perfectly konami like just not ugly :D
2. the card should be in english so everyone can understand them
3. the script for the cards should work and be play testet, if they have minor bugs thats no problem, that happens, but they should be fixed when seen.
   
i think thats it

if you want to have the cards in this repo in EdoPro you need to do the following

Create a file in your config folder of Projectignis (normaly in C:\ProjectIgnis) with the name "user_config.json" (if you already have one, you probably already know how this works :D)

next open the file with any text editor and add following
```
{
    "repos": [
	      {
               "url": "https://github.com/Coroln/Custom-cards",
                "repo_name": "Coroln Scripts",
                "repo_path": "./repositories/Coroln",
                "script_path": "script",
                "should_update": true,
                "should_read": true
        }
    ],
    "servers": [
        {
            "name" : "CCS_unofficial",
            "address": "212.132.121.56",
            "duelport": 7911,
            "roomaddress": "212.132.121.56",
            "roomlistprotocol": "http",
            "roomlistport": 7922
        }
    ]
}
```

now save the file.

now when you start/restart EdoPro it should download all the cards in this repo, also when you click on servers you should see a server named CCS_unofficial where you can play with these cards, but mind the server is not strong so it could be that it is offline

# Discord
when you need a place to find friends to play with join my discord server. It was originally intended as my YouTube community discord but I upload so rarely that it makes more sense for this

https://discord.gg/RCAwZ8V8ee

# Youtube
I rarely upload but if you are still interested come and have a look

but mind my videos are normaly in German :D

https://www.youtube.com/@Coroln
