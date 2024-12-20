//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
enum Status {
    TODO,
    DOING,
    DONE
}
struct Todo {
    string definition;
    Status status;
    uint256 createdAt;
}

contract TodoList is Ownable {
    Todo[] public todoList;

    event CreateTodo(address indexed owner, Todo todo);

    uint256 public fee = 0.01 ether;

    constructor() Ownable(msg.sender) {}

    function createTodo(string calldata _todoDefinition) public payable onlyOwner validDefinition(_todoDefinition) {
        require(msg.value >= fee, "Must send at least 0.01 ETH");

        uint256 refund = msg.value - fee;
        if (refund > 0) {
            (bool success, ) = payable(msg.sender).call{ value: refund }("");
            require(success, "Failed to send refund");
        }

        Todo memory todo = Todo(_todoDefinition, Status.TODO, block.timestamp);
        todoList.push(todo);

        emit Received(msg.sender, msg.value, refund);
        emit CreateTodo(msg.sender, todo);
    }

    event UpdateTodo(address indexed owner, Todo todo);

    function updateTodo(
        uint256 _index,
        Status _status,
        string calldata _todoDefinition
    ) public onlyOwner validDefinition(_todoDefinition) inbounds(_index) {
        todoList[_index].status = _status;
        todoList[_index].definition = _todoDefinition;

        emit UpdateTodo(msg.sender, todoList[_index]);
    }

    event DeleteTodo(address indexed owner, string todoName);

    function deleteTodo(uint256 _index) public onlyOwner inbounds(_index) {
        string memory todoDefinition = todoList[_index].definition;

        // Check if there's a Todo to delete
        require(bytes(todoDefinition).length > 0, "No Todo found");

        // Remove Todo and avoid blank having blank Todos
        todoList[_index] = todoList[todoList.length - 1];
        todoList.pop();

        // Refund user of fee (if balance permits)
        require(payable(this).balance >= fee, "Insufficient contract balance for refund");
        
        (bool success, ) = payable(msg.sender).call{ value: fee }("");
        require(success, "Refund failed");

        emit DeleteTodo(msg.sender, todoDefinition);
    }

    event GetTodos(address indexed owner, Todo[] todos);

    function getTodos() public view returns (Todo[] memory) {
        return todoList;
    }

    modifier validDefinition(string calldata _todoDefinition) {
        require(bytes(_todoDefinition).length > 0, "Todo definition must contain characters");
        _;
    }

    modifier inbounds(uint256 _index) {
        require(_index < todoList.length, "Index is out of bounds");
        _;
    }

    function getNumOfTodos() public view returns (uint256) {
        return todoList.length;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    event Withdrawal(address to, uint256 amount);

    function withdraw() public onlyOwner {
        uint256 balance = payable(this).balance;
        (bool success, ) = payable(msg.sender).call{ value: balance }("");
        require(success, "Withdrawal failed");

        emit Withdrawal(msg.sender, balance);
    }

    event Received(address sender, uint256 kept, uint256 returned);

    receive() external payable {
        emit Received(msg.sender, msg.value, 0);
    }
}
