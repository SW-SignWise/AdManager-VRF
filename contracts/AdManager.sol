// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

/// @title AdManager Contract
/// @author Cristian Richarte Gil
/// @notice Contract managing ads through Chainlink VRF (Verifiable Random Function)
/// @dev Uses Chainlink's VRFConsumerBaseV2 to generate random numbers for ad selection

contract AdManager is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId; // Subscription ID for VRF
    address vrfCoordinator = 0x2eD832Ba664535e5886b75D64C46EB9a228C2610; // Avax-Fuji VRF Coordinator address
    bytes32 s_keyHash =
        0x354d2f95da55398f44b7cff77da56283d9c6c829a4bdf1bbcaf2ad6a4d081f61; // Key hash for VRF
    uint32 callbackGasLimit = 100000; // Gas limit for VRF callback
    uint16 requestConfirmations = 3; // Number of confirmations required for VRF request

    uint32 numWords = 1; // Number of random numbers to request
    address s_owner; // Address of the contract owner

    event newRandomAdRequest(uint256 indexed requestId); // Event emitted when a new random number for ad selection is requested
    event randomWordLanded(uint256 indexed requestId, uint256[] randomWords); // Event emitted when random words are received
    event numWordsUpdated(uint8 numWordsUpdated); // Event emitted when the number of random words to request is updated

    modifier onlyOwner() {
        require(msg.sender == s_owner, "Caller is not the owner");
        _;
    }

    /**
     * @notice Constructor to initialize VRF Coordinator and subscription ID
     * @param subscriptionId Subscription ID used by the consumer contract
     */
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    /**
     * @notice Requests randomness from Chainlink VRF
     * @return requestId The ID of the random number request
     */
    function requestRandomWords() public onlyOwner returns (uint256 requestId) {
        requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        emit newRandomAdRequest(requestId);
    }

    /**
     * @notice Callback function to receive and process the generated random numbers
     * @param requestId The ID of the random number request
     * @param randomWords Array of random numbers generated by VRF
     */
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        emit randomWordLanded(requestId, randomWords);
    }

    /**
     * @notice Updates the number of words to be requested for randomness
     * @param _numWords New number of words to request
     */
    function updateAmountWords(uint8 _numWords) external onlyOwner {
        require(_numWords != 0, "numWords must be non-zero");
        numWords = _numWords;
        emit numWordsUpdated(_numWords);
    }
}
