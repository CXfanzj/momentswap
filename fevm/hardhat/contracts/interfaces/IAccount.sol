// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @notice Data stored for each user account.
struct AccountData {
    address owner;              // The address that owns this account.
    string avatarURI;           // The URI of the avatar image associated with this account.
    uint120[] momentIds;        // An array of IDs representing the moments created by this account.
    uint128[] commentIds;       // An array of IDs representing the comments made by this account.
    uint120[] likedMomentIds;   // An array of IDs representing the moments that this account has liked.
    uint64[] mintedSpaceIds;    // An array of IDs representing the spaces that this account has created.
    uint64[] rentedSpaceIds;    // An array of IDs representing the spaces that this account is currently renting.
}

/// @title Account Contract Interface
/// @notice This interface defines the methods that can be called on the account contract.
interface IAccount {

    /// @notice Returns the account IDs of the given addresses.
    /// @dev If an address does not have an account, it is omitted from the result.
    /// @param addresses The list of addresses for which to retrieve the account IDs.
    /// @return An array of account IDs corresponding to the given addresses.
    function getAccountIds(address[] calldata addresses) external view returns (uint64[] memory);

    /// @notice Returns the addresses corresponding to the given account IDs.
    /// @dev If an account ID does not exist, it is omitted from the result.
    /// @param accountIds The list of account IDs for which to retrieve the addresses.
    /// @return An array of addresses corresponding to the given account IDs.
    function getAddresses(uint64[] calldata accountIds) external view returns (address[] memory);

    /// @notice Returns the account data for the given account IDs.
    /// @dev If an account ID does not exist, it is omitted from the result.
    /// @param accountIds The list of account IDs for which to retrieve the account data.
    /// @return An array of account data corresponding to the given account IDs.
    function getAccountData(uint64[] calldata accountIds) external view returns (AccountData[] memory);

    /// @notice Returns the avatar URIs for the given account IDs.
    /// @dev If an account ID does not exist, it is omitted from the result.
    /// @param accountIds The list of account IDs for which to retrieve the avatar URIs.
    /// @return An array of avatar URIs corresponding to the given account IDs.
    function getAvatarURIs(uint64[] calldata accountIds) external view returns (string[] memory);

    /// @notice Returns the moment IDs associated with the given account ID.
    /// @param accountId The ID of the account for which to retrieve the moment IDs.
    /// @return An array of moment IDs associated with the given account ID.
    function getMomentIds(uint64 accountId) external view returns (uint120[] memory);

    /// @notice Returns the comment IDs associated with the given account ID.
    /// @param accountId The ID of the account for which to retrieve the comment IDs.
    /// @return An array of comment IDs associated with the given account ID.
    function getCommentIds(uint64 accountId) external view returns (uint128[] memory);

    /// @notice Returns the moment IDs that the account has liked.
    /// @param accountId The ID of the account for which to retrieve the liked moment IDs.
    /// @return An array of moment IDs that the account has liked.
    function getLikedMomentIds(uint64 accountId) external view returns (uint120[] memory);

    /// @notice Returns the IDs of the spaces minted by the given account ID.
    /// @param accountId The ID of the account for which to retrieve the minted space IDs.
    /// @return An array of space IDs minted by the given account ID.
    function getMintedSpaceIds(uint64 accountId) external view returns (uint64[] memory);

    /// @notice Returns the IDs of the spaces rented by the given account ID.
    /// @param accountId The ID of the account for which to retrieve the rented space IDs.
    /// @return An array of space IDs rented by the given account ID.
    function getRentedSpaceIds(uint64 accountId) external view returns (uint64[] memory);

    /// @notice Creates a new account with the given domain name and avatar URI.
    /// @param domainName The domain name to associate with the account.
    /// @param avatarURI The URI of the avatar to associate with the account.
    /// @return The ID of the newly created account.
    function createAccount(string calldata domainName, string calldata avatarURI) external returns (uint64);

    /// @notice Cancels the account associated with the given account ID.
    /// @dev The account must not have any associated moments, comments, or spaces in order to be cancelled.
    /// @param accountId The ID of the account to cancel.
    function cancelAccount(uint64 accountId) external;

    /// @notice Updates the avatar URI associated with the calling account.
    /// @param avatarURI The new avatar URI to associate with the calling account.
    function updateAvatarURI(string calldata avatarURI) external;

    /// @notice Creates a new moment with the given metadata URI.
    /// @param metadataURI The URI of the metadata to associate with the moment.
    /// @return The ID of the newly created moment.
    function createMoment(string calldata metadataURI) external returns (uint120);

    /// @notice Removes the moment associated with the given moment ID.
    /// @dev The calling account must be the owner of the moment in order to remove it.
    /// @param momentId The ID of the moment to remove.
    function removeMoment(uint120 momentId) external;

    /// @notice Adds a like to the moment associated with the given moment ID from the calling account.
    /// @dev The calling account must not have already liked the moment.
    /// @param momentId The ID of the moment to like.
    function likeMoment(uint120 momentId) external;

    /// @notice Cancels the like from the calling account to the moment associated with the given moment ID.
    /// @dev The calling account must have already liked the moment.
    /// @param momentId The ID of the moment to cancel the like for.
    function cancelLikeMoment(uint120 momentId) external;

    /// @notice Creates a new comment on the moment associated with the given moment ID with the given comment text.
    /// @param momentId The ID of the moment to create the comment on.
    /// @param commentText The text of the comment to create.
    /// @return The ID of the newly created comment.
    function createComment(uint120 momentId, string calldata commentText) external returns (uint128);

    /// @notice Removes the comment associated with the given comment ID.
    /// @dev The calling account must be the owner of the comment in order to remove it.
    /// @param commentId The ID of the comment to remove.
    function removeComment(uint128 commentId) external;

    /// @notice Mints a new child space domain with the given domain name and expire time.
    /// @dev The calling account must own the parent space in order to mint a child space domain.
    /// @param parentSpaceId The ID of the parent space to mint the child space domain for.
    /// @param domainName The domain name to associate with the child space domain.
    /// @param expireSeconds The number of seconds until the child space domain expires.
    /// @return The ID of the newly minted child space domain.
    function mintChaildSpaceDomain(uint64 parentSpaceId, string calldata domainName, uint64 expireSeconds) external returns (uint64);

    /// @notice Returns the space with the given space ID.
    /// @param spaceId The ID of the space to return.
    function returnSpace(uint64 spaceId) external;

    /// @notice Updates the domain name for the rented space with the given space ID.
    /// @param spaceId The ID of the rented space for which to update the domain name.
    /// @param domainName The new domain name to set.
    function updateRentedSpaceDomainName(uint64 spaceId, string calldata domainName) external;
}