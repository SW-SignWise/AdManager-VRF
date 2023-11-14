// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

contract AdManager is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;

    uint64 s_subscriptionId;
    address vrfCoordinator = 0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed; // Polygon Mumbai
    bytes32 s_keyHash =
        0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f;
    uint32 callbackGasLimit = 40000;
    uint16 requestConfirmations = 1;

    // For this example, retrieve 1 random value in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 1;
    address s_owner;

    event newRandomAd(uint256 indexed adIndex);

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    /**
     * @notice Constructor inherits VRFConsumerBaseV2
     *
     * @dev NETWORK: Mumbai
     *
     * @param subscriptionId subscription id that this consumer contract can use
     */
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    /**
     * @notice Requests randomness
     * @dev Warning: if the VRF response is delayed, avoid calling requestRandomness repeatedly
     * as that would give miners/VRF operators latitude about which VRF response arrives first.
     * @dev You must review your implementation details with extreme care.
     *
     * @param adsLength max index value. This value will determine the Index of the available Ads to show next time.
     */
    function getRandomAd(
        uint256 adsLength
    ) public onlyOwner returns (uint256 adIndex) {
        uint256 requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        adIndex = requestId % adsLength;

        emit newRandomAd(adIndex);
    }

    // Needed to override for compilation, not needed as random number is emitted while request on the event "newRandomAd".
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {}
}
