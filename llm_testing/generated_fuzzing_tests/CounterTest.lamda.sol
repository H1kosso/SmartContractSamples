import "@forge-std/Test.sol";

contract CounterTest {
    Counter counter;

    beforeEach() {
        counter = new Counter();
    }

    test("Setting the number to a very large value should not overflow", async () => {
        // Set the number to a very large value
        uint256 veryLargeNumber = 2**255;
        await counter.setNumber(veryLargeNumber);

        // Assert that the number is indeed set to the expected value
        assert(await counter.number == veryLargeNumber);
    });
}