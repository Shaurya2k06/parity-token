// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ReentrancyGuardUpgradeable} from "lib/openzeppelin-contracts-upgradeable/contracts/security/ReentrancyGuardUpgradeable.sol";

contract ParityToken is Initializable, UUPSUpgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable, IERC20, IERC20Metadata {
    uint256 private _totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 initialSupply) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _totalSupply = initialSupply;
        balanceOf[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    /**
     * @dev Metadata functions for the Parity Token.
     * Includes name, symbol, decimals, and total supply.
     */

    function name() public pure returns (string memory) {
        return "Parity Token";
    }
    function symbol() public pure returns (string memory) {
        return "PRTY";
    }
    function decimals() public pure returns (uint8) {
        return 18;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Invalid recipient");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Invalid recipient");
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 value) public onlyOwner returns (bool success) {
        _mint(to, value);
        return true;
    }

    function burn(uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _totalSupply -= value;
        balanceOf[msg.sender] -= value;
        emit Transfer(msg.sender, address(0), value);
        return true;
    }

    function transferWithData(address to, uint256 value, bytes memory) public returns (bool success) {
        require(to != address(0), "Invalid recipient");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferWithDataAndCallback(address to, uint256 value, bytes memory data) public nonReentrant returns (bool) {
        require(to != address(0), "Invalid recipient");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(to.code.length > 0, "Recipient must be a contract");

        // Update balances before the callback to prevent reentrancy
        _transfer(msg.sender, to, value);

        // Perform the callback
        (bool callSuccess, bytes memory returnData) = to.call(data);
        require(callSuccess, returnData.length > 0 ? _getRevertMsg(returnData) : "Callback failed");

        return true;
    }

    function _getRevertMsg(bytes memory returnData) internal pure returns (string memory) {
        if (returnData.length < 68) return "Transaction reverted silently";
        bytes memory revertData = slice(returnData, 4, returnData.length - 4);
        return abi.decode(revertData, (string));
    }

    function slice(bytes memory data, uint256 start, uint256 length) internal pure returns (bytes memory result) {
        require(start + length <= data.length, "Slice out of bounds");
        result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = data[start + i];
        }
        return result;
    }

    
        function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "Invalid Owner");
        require(spender != address(0), "Invalid Spender");
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _mint(address to, uint256 value) internal {
        require(to != address(0), "Invalid Recipient");
        _totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    function _transfer(address from, address to, uint256 value) internal {
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    /// @dev Required override for UUPS proxy pattern
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
