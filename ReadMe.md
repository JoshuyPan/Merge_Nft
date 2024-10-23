### <span style="color: grey;">MERGE NFT GAME</span> ###

The hint:

```
Something small. 

What about a project where you can mint an animal nft and build a function that you can mutate 2 together, (delete  the two nft’s and create a new nft that’s stronger?) 

Any address can only mint 6 in total so that means they can get 3 stronger nft’s by the end of it?
```

### <span style="color: green;">Here My Solution:</span>

You have to interact with my package that lives on the testnet at the address: 0x028f6c1183946a21565fb6d1a4eea087ab64b3bc5f04849dcd61915456780a85

When i deployed my Package, i created a GameChecker struct (SharedObject, it must me in order to be accessible by anyone). Its functionality is to make sure,
you can't register more than 1 user per address (feature that actually works, you can try calling create_account more than one and it will reverts)
and prevents you to mint more than 6 total nfts (Works).

With that said, you interact ONLY with the entry functions that lives in the 'game' module:

GameCheckerAddr = 0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd
packageAddr = 0x028f6c1183946a21565fb6d1a4eea087ab64b3bc5f04849dcd61915456780a85

### FUNCTIONS
### <span style="color: green;"> register_new_user:</span>

arg1 -> GameCheckerAddr = 0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd
username -> you have to pass it like: \"YourName\"

example call:

```bash
sui client ptb \
--gas-budget 100000000 \
--move-call 0x028f6c1183946a21565fb6d1a4eea087ab64b3bc5f04849dcd61915456780a85::game::register_new_user @0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd \"YourName\"
```

Now you can forgot you user struct, cause we will interact with the other 2 functions passing to them just the GameChecker. It will handle all the stuffs
related to your account, like checking your grade (yes, you have grades based on how many special nft you created (merged ones)), making sure you don't exceed the
max amount of NFTs and so on.

But leave a page opened of your account struct address, so you can see the changes as they occours.

### TRY TO CALL AGAIN CREATE USER AND WILL REVERT :3

### <span style="color: green;"> mint_nft</span>

arg1 -> GameCheckerAddr = 0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd

example call:

```bash
sui client ptb \
--gas-budget 100000000 \
--move-call 0x028f6c1183946a21565fb6d1a4eea087ab64b3bc5f04849dcd61915456780a85::game::mint_nft @0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd
```

I designed the create_nft in NFT module to generate a random name and random attack and defence that will be used to generate a special NFT later,
normal nfts have the isMutable field set to true, special ones to false. So you can't merge an nft with a special one (We'll see it when we'll use the merge nft function).
The problem here is that name, attack and defence are not casual and always evaluates to "Racoon" attack 31 defence 31.

BTW, call the function again, so you'll own 2 NFTs (they're identical, ....details...).
This is the only bug i have, i think is related on how the random index is picked, but its just a sidequest, lets skip for now.

at this point save both the ID's, we'll need them in the next function.

### <span style="color: green;"> merge_nfts</span>

arg1 -> GameCheckerAddr = 0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd
arg2 -> NFT1 to merge (You must be the owner or reverts)
arg3 -> NFT2 to merge (You must be the owner or reverts)

example call:

```bash
sui client ptb \
--gas-budget 100000000 \
--move-call 0x028f6c1183946a21565fb6d1a4eea087ab64b3bc5f04849dcd61915456780a85::game::merge_nfts @0xac0bf070208b44fbf7d583c7dbd855e3dd5b26009be2ae0501b59f41b974a6fd @0xYOURFIRSTNFTTOMERGEID @0xYOURSECONDNFTTOMERGEID 
```

Yeah man, now if you check your nfts on https://testnet.suivision.xyz/ you will see that the owner of them is the address 0x000000000000 (burnt)
in addition you have a new special NFT that sits to your address and if you check your account object again, now your merges increased by 1 and you
switched the grade from "Noob" to "Merger", to check the other one grades look into user package -> try_update_user_grade()

So, at the end, i can say that i'm satisfied, expept for the casuality of stats of the nfts that i should fix, but the goal here is another:

- We have a GRADE on user that works and rappresent your "Archievments".
- We have a GAMECHECKER that manage all the game and its a shared object, a new concept that i've learned.

GameChecker is a wonderful creature. I love her.

If you read util here, a special thanks to being annoyed by me.
CryptoTurtle


