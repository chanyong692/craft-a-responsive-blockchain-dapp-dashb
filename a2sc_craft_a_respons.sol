pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol";

contract CraftADashboard {
    // Mapping of user addresses to their corresponding dashboard data
    mapping (address => DashboardData) public dashboardData;

    // Structure to hold dashboard data
    struct DashboardData {
        uint256 totalCrafted;
        uint256 totalBurned;
        uint256[] craftedItems;
        uint256[] burnedItems;
    }

    // Event emitted when a new item is crafted
    event NewItemCrafted(address indexed user, uint256 itemId);

    // Event emitted when an item is burned
    event ItemBurned(address indexed user, uint256 itemId);

    // Modifier to check if a user has already crafted an item
    modifier onlyIfNotCrafted(uint256 _itemId) {
        require(!hasCrafted(msg.sender, _itemId), "Item already crafted");
        _;
    }

    // Modifier to check if a user has already burned an item
    modifier onlyIfNotBurned(uint256 _itemId) {
        require(!hasBurned(msg.sender, _itemId), "Item already burned");
        _;
    }

    // Function to craft a new item
    function craftItem(uint256 _itemId) public onlyIfNotCrafted(_itemId) {
        dashboardData[msg.sender].totalCrafted++;
        dashboardData[msg.sender].craftedItems.push(_itemId);
        emit NewItemCrafted(msg.sender, _itemId);
    }

    // Function to burn an item
    function burnItem(uint256 _itemId) public onlyIfNotBurned(_itemId) {
        dashboardData[msg.sender].totalBurned++;
        dashboardData[msg.sender].burnedItems.push(_itemId);
        emit ItemBurned(msg.sender, _itemId);
    }

    // Function to check if a user has crafted an item
    function hasCrafted(address _user, uint256 _itemId) public view returns (bool) {
        for (uint256 i = 0; i < dashboardData[_user].craftedItems.length; i++) {
            if (dashboardData[_user].craftedItems[i] == _itemId) {
                return true;
            }
        }
        return false;
    }

    // Function to check if a user has burned an item
    function hasBurned(address _user, uint256 _itemId) public view returns (bool) {
        for (uint256 i = 0; i < dashboardData[_user].burnedItems.length; i++) {
            if (dashboardData[_user].burnedItems[i] == _itemId) {
                return true;
            }
        }
        return false;
    }
}