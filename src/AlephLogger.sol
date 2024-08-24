pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import "@chainlink/contracts/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";


contract AlephLogger is VRFConsumerBaseV2Plus {

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus)
        public s_requests; /* requestId --> requestStatus */

    // Your subscription ID.
    uint256 public s_subscriptionId;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf/v2-5/supported-networks
    bytes32 public keyHash = 0x719ed7d7664abc3001c18aac8130a2265e1e70b7e036ae20f3ca8b92b3154d86;

    // Past request IDs.
    uint256[] public requestIds;
    uint256 public lastRequestId;

     // The default is 3, but you can set this higher.
    uint16 public requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2_5.MAX_NUM_WORDS.
    uint32 public numWords = 2;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 public callbackGasLimit = 100000;

    /**
     * HARDCODED FOR SEPOLIA
     * COORDINATOR: 
     * subscription: subscriptionId
     */
    constructor(
        uint256 subscriptionId
    ) VRFConsumerBaseV2Plus(0xec0Ed46f36576541C75739E915ADbCb3DE24bD77) {
        s_subscriptionId = subscriptionId;
    }

    

    // Mapping to store logged users
    mapping(address => string) public loggedUsers;

    // Flag to enable debugging
    bool public debugging;

    // Event emitted when the HelloWorld function is called
    event HelloWorld(address userAddress, string solanaAddress);

    // Assumes the subscription is funded sufficiently.
    // @param enableNativePayment: Set to `true` to enable payment in native tokens, or
    // `false` to pay in LINK
    function requestRandomWords(
        bool enableNativePayment
    ) internal  returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function getRequestStatus(
        uint256 _requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] calldata _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    /**
     * @notice Sets the debugging flag
     * @dev Only the owner can set the debugging flag
     * @param _debuggingFlag Whether to enable or disable debugging
     */
    function setDebuggingFlag(bool _debuggingFlag) public onlyOwner {
        debugging = _debuggingFlag;
    }
    

    /**
     * @notice Calls the greet function
     * @dev Adds the solana address to the logged users mapping and emits the HelloWorld event
     * @param _solanaAddress The solana address to add to the logged users mapping
     */
    function greet(string memory _solanaAddress) public {
        // Check if debugging is enabled and if the address already exists in the mapping
        if (debugging && bytes(loggedUsers[msg.sender]).length > 0) {
            revert("Address already logged");
        }

        // Add the solana address to the logged users mapping
        loggedUsers[msg.sender] = _solanaAddress;


        requestRandomWords(true);



        // Emit the HelloWorld event
        emit HelloWorld(msg.sender, _solanaAddress);
    }

    // Optional function to get the logged address for a user
    function getLoggedAddress(address _userAddress) public view returns (string memory) {
        return loggedUsers[_userAddress];
    }
}
