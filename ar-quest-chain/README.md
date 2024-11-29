# QuestVerse Core Smart Contract - README

QuestVerse is a location-based augmented reality (AR) gaming platform that leverages blockchain technology to create a decentralized and interactive gaming ecosystem. The core smart contract for QuestVerse manages players, in-game locations, items, achievements, and a leaderboard. The contract ensures that players are rewarded for completing challenges and achieving milestones, while also allowing for secure trading and ownership of in-game assets via NFTs (Non-Fungible Tokens).

The QuestVerse Core Smart Contract implements the following key features:
- Player registration and location tracking
- Location-based challenges with rewards
- Achievement system with points and NFT minting
- In-game item management and trading
- A leaderboard that tracks player scores

---

## Key Features

### 1. **Player Management**
   - **Register Player:** New players can register on the platform to start participating in the game.
   - **Update Player Location:** Players can update their current geographic location, which is used to trigger location-based challenges.
   - **Player Score & Inventory:** Players earn points (score) and collect items as they complete challenges. These items are stored as NFTs on the blockchain.

### 2. **Location-Based Challenges**
   - **Add Location:** Administrators can add new locations to the game where challenges will be located. Each location is associated with a reward and can be activated or deactivated.
   - **Check Location:** Players can check if they are close enough to a location to claim its reward. The system ensures that only one player can claim a specific location.
   - **Claim Location:** When a player reaches an active location within a predefined distance, they can claim the reward, which includes a score boost and an NFT item.
   
### 3. **NFTs for Items and Achievements**
   - **Game Items:** Players can earn in-game items by completing challenges. These items are represented as NFTs, ensuring true ownership and tradability.
   - **Achievements:** Players can unlock achievements based on their in-game progress. Each achievement is represented as an NFT and provides additional points to the player’s score.

### 4. **Leaderboard**
   - The leaderboard tracks the scores of players and allows for the display of top players. The leaderboard is updated dynamically based on player progress.

### 5. **Trading System**
   - Players can transfer in-game items to other players, facilitating an in-game economy.

### 6. **Admin Functions**
   - **Location Management:** Only the contract owner (administrator) can add new locations to the game.
   - **Reward and Achievement Management:** Administrators can define rewards, achievements, and manage their respective minting process.

---

## Data Structures

### Maps:
1. **players:** Stores information about each player.
   - `score`: The player’s total score.
   - `items`: List of in-game item NFTs the player owns.
   - `achievements`: List of achievement NFTs the player has unlocked.
   - `last-location`: The last known location (latitude and longitude) of the player.

2. **locations:** Stores information about each challenge location.
   - `latitude`: Latitude of the location.
   - `longitude`: Longitude of the location.
   - `reward-type`: The type of reward the location offers (e.g., item, points).
   - `active`: Whether the location is active and available for players to claim.
   - `claimed-by`: The player who has already claimed the location.

3. **items:** Stores information about in-game items.
   - `name`: The name of the item.
   - `rarity`: The rarity level of the item (e.g., common, rare, epic).
   - `power`: The power or benefit of the item (e.g., boost points, special abilities).

4. **achievements:** Stores information about achievements.
   - `name`: Name of the achievement.
   - `description`: A brief description of the achievement.
   - `points`: The number of points awarded for unlocking the achievement.

5. **leaderboard:** Tracks the highest scores and associated players.

### Non-Fungible Tokens (NFTs):
- **game-item:** Represents an in-game item that players can collect and trade.
- **achievement:** Represents a player's achievement, unlocking points and contributing to their score.

---

## Functions

### Administrative Functions
1. **add-location:** Adds a new location to the game with a specified latitude, longitude, and reward type.
2. **award-achievement:** Awards a specific achievement to the player, minting an NFT for the achievement and increasing the player’s score.
   
### Player Functions
1. **register-player:** Registers a new player in the game.
2. **update-player-location:** Updates the player's current geographic location (latitude and longitude).
3. **check-location:** Checks if the player is within range of an active location that has not been claimed yet.
4. **claim-location:** Claims the reward at a specified location if the player is within the allowed distance and the location is active.
5. **transfer-item:** Allows players to trade in-game items by transferring NFTs.

### Game Mechanics Functions
1. **calculate-distance:** Calculates the distance between two geographical points (latitudes and longitudes).
2. **update-leaderboard:** Updates the leaderboard with the player’s current score.

### Read-Only Functions
1. **get-player-info:** Retrieves information about a player, including their score, items, and achievements.
2. **get-location-info:** Retrieves information about a specific location, including its status (active or claimed).
3. **get-item-info:** Retrieves information about a specific item, including its name, rarity, and power.
4. **get-achievement-info:** Retrieves information about a specific achievement.

---

## Deployment & Usage

### Prerequisites
- This smart contract is designed to be deployed on the Stacks blockchain using the Clarity language. Ensure you have a Stacks wallet to interact with the contract.
- The contract owner (administrator) must have the necessary permissions to add locations and manage the game settings.

### How to Use:
1. **Register as a Player:** Players can register themselves by calling the `register-player` function. This initializes their profile, including score and inventory.
2. **Update Location:** Players should call the `update-player-location` function to update their geographic position.
3. **Claim Locations:** Players can interact with the game by visiting locations and claiming rewards if they are close enough. This is done by calling `check-location` followed by `claim-location`.
4. **Earn Achievements:** Players can unlock achievements by reaching certain milestones in the game, such as completing challenges or accumulating points. These achievements are minted as NFTs.
5. **Trade Items:** Players can trade in-game items by using the `transfer-item` function to send items to other players.
6. **View Leaderboard:** Players can view their current position on the leaderboard by checking their score relative to others.

---

## Future Enhancements

- **Advanced Distance Calculation:** Implement more accurate distance calculation using the Haversine formula for greater precision in location-based challenges.
- **Player-to-Player Trading:** Extend the trading system to include in-game item auctions and bidding.
- **Enhanced Leaderboard Logic:** Implement more sophisticated leaderboard ranking based on different criteria such as achievements, location claims, and time spent playing.

---

The **QuestVerse Core Smart Contract** provides a foundational layer for an AR-based gaming ecosystem on the blockchain. By combining location-based challenges, NFTs for rewards and achievements, and a decentralized economy, QuestVerse offers an engaging experience for players while ensuring secure, transparent, and immutable records of player progress and asset ownership. 

Feel free to contribute to the project or build on this contract to enhance the QuestVerse ecosystem!