import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    def test_simple(self):
        # Load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")
        
        # Create array0 in the data section
        array0 = t.array([5, 10, -3])
        # Load address of `array0` into register a0
        t.input_array("a0", array0)
        
        # Create array1 in the data section
        array1 = t.array([3, 7, 2])
        # Load address of `array1` into register a1
        t.input_array("a1", array1)
        
        # Set a2 to the length of the array
        t.input_scalar("a2", 3)
        
        # Create a result array in the data section (fill values with -1)
        result_array = t.alloc_array(3)
        # Load address of `result_array` into register a3
        t.input_array("a3", result_array)
        
        # Call the `abs_loss` function
        t.call("abs_loss")
        
        # Check that the result array contains the correct output
        t.check_array(result_array, [2, 3, 5])
        
        # Check that the register a0 contains the correct output
        t.check_scalar("a0", 10)
        
        # Generate the `assembly/TestAbsLoss_test_simple.s` file and run it through venus
        t.execute()

    def test_array_length_less_than_one(self):
        # Load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # Create array0 in the data section with length less than 1
        array0 = t.array([])
        # Load address of `array0` into register a0
        t.input_array("a0", array0)

        # Create array1 in the data section
        array1 = t.array([3, 7, 2])
        # Load address of `array1` into register a1
        t.input_array("a1", array1)

        # Set a2 to the length of the arrays (which is 0)
        t.input_scalar("a2", 0)

        # Create a result array in the data section (fill values with -1)
        result_array = t.array([-1, -1, -1])
        # Load address of `result_array` into register a3
        t.input_array("a3", result_array)

        # Call the `abs_loss` function
        t.call("abs_loss")

        # Check that the result array is empty
        t.check_array(result_array, [-1, -1, -1])

        # Check that the register a0 contains the correct output (should be 36 for length less than 1)
        t.check_scalar("a0", 36)

        # Generate the test assembly file and run it through venus
        t.execute()

    def test_malloc_error(self):
        # Load the test for abs_loss.s
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # Create array0 in the data section
        array0 = t.array([5, 10, -3])
        # Load address of `array0` into register a0
        t.input_array("a0", array0)

        # Create array1 in the data section
        array1 = t.array([3, 7, 2])
        # Load address of `array1` into register a1
        t.input_array("a1", array1)

        # Set a2 to the length of the arrays
        t.input_scalar("a2", 3)

        # Create a result array in the data section with a small size that would cause malloc error
        result_array = t.array([-1, -1, -1])
        # Load address of `result_array` into register a3
        t.input_array("a3", result_array)

        # Call the `abs_loss` function
        t.call("abs_loss")

        # Check that the result array is empty
        t.check_array(result_array, [-1, -1, -1])

        # Check that the register a0 contains the malloc error code (should be 26)
        t.check_scalar("a0", 26)

        # Generate the test assembly file and run it through venus
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def test_simple(self):
        # load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # create input arrays in the data section
        arr0 = t.array([2, 4, 6, 8, 10])
        arr1 = t.array([3, 6, 9, 12, 15])

        # load array addresses into argument registers
        t.input_array("a0", arr0)
        t.input_array("a1", arr1)

        # load array length into argument register
        t.input_scalar("a2", 5)

        # create a result array in the data section (fill values with -1)
        result_arr = t.array([-1, -1, -1, -1, -1])

        # load result array address into argument register
        t.input_array("a3", result_arr)

        # call the `squared_loss` function
        t.call("squared_loss")

        # check that the result array contains the correct output
        t.check_array("a3", [1, 4, 9, 16, 25])

        # check that the register a0 contains the correct output
        t.check_scalar("a0", 55)

        # generate the `assembly/TestSquaredLoss_test_simple.s` file and run it through venus
        t.execute()

    def test_array_length_less_than_one(self):
        # Load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # Create array0 in the data section with length less than 1
        array0 = t.array([])
        # Load address of `array0` into register a0
        t.input_array("a0", array0)

        # Create array1 in the data section
        array1 = t.array([3, 7, 2])
        # Load address of `array1` into register a1
        t.input_array("a1", array1)

        # Set a2 to the length of the arrays (which is 0)
        t.input_scalar("a2", 0)

        # Create a result array in the data section (fill values with -1)
        result_array = t.array([-1, -1, -1])
        # Load address of `result_array` into register a3
        t.input_array("a3", result_array)

        # Call the `squared_loss` function
        t.call("squared_loss")

        # Check that the result array is empty
        t.check_array(result_array, [-1, -1, -1])

        # Check that the register a0 contains the correct output (should be 36 for length less than 1)
        t.check_scalar("a0", 36)

        # Generate the test assembly file and run it through venus
        t.execute()

    def test_malloc_error(self):
        # Load the test for squared_loss.s
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # Create array0 in the data section
        array0 = t.array([5, 10, -3])
        # Load address of `array0` into register a0
        t.input_array("a0", array0)

        # Create array1 in the data section
        array1 = t.array([3, 7, 2])
        # Load address of `array1` into register a1
        t.input_array("a1", array1)

        # Set a2 to the length of the arrays
        t.input_scalar("a2", 3)

        # Create a result array in the data section with a small size that would cause malloc error
        result_array = t.array([-1, -1, -1])
        # Load address of `result_array` into register a3
        t.input_array("a3", result_array)

        # Call the `squared_loss` function
        t.call("squared_loss")

        # Check that the result array is empty
        t.check_array(result_array, [-1, -1, -1])

        # Check that the register a0 contains the malloc error code (should be 26)
        t.check_scalar("a0", 26)

        # Generate the test assembly file and run it through venus
        t.execute()
    # Add other test cases if necessary


    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def test_simple(self):
        # Load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # Create input arrays in the data section
        array0 = t.array([0, 1, 1, 0])
        array1 = t.array([0, 0, 1, 1])
        # Load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)

        # Load array length into argument register
        t.input_scalar("a2", 4)

        # Create a result array in the data section (fill values with -1)
        result_array = t.array([-1, -1, -1, -1])
        # Load result array address into argument register
        t.input_array("a3", result_array)

        # Call the `zero_one_loss` function
        t.call("zero_one_loss")

        # Check that the result array contains the correct output
        t.check_array(result_array, [1, 0, 1, 0])

        # Generate the test assembly file and run it through venus
        t.execute()

    def test_array_length_less_than_one(self):
        # Load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # Create input arrays in the data section
        array0 = t.array([])
        array1 = t.array([0, 1, 1, 0])
        # Load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)

        # Load array length into argument register
        t.input_scalar("a2", 0)

        # Create a result array in the data section (fill values with -1)
        result_array = t.array([-1, -1, -1, -1])
        # Load result array address into argument register
        t.input_array("a3", result_array)

        # Call the `zero_one_loss` function
        t.call("zero_one_loss")

        # Check that the result array is empty
        t.check_array(result_array, [])

        # Generate the test assembly file and run it through venus
        t.execute()

    def test_malloc_error(self):
        # Load the test for zero_one_loss.s
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # Create input arrays in the data section
        array0 = t.array([0, 1, 1, 0])
        array1 = t.array([0, 0, 1, 1])
        # Load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)

        # Load array length into argument register
        t.input_scalar("a2", 4)

        # Create a result array in the data section with a small size that would cause malloc error
        result_array = t.array([-1])
        # Load result array address into argument register
        t.input_array("a3", result_array)

        # Call the `zero_one_loss` function
        t.call("zero_one_loss")

        # Check that the result array is empty
        t.check_array(result_array, [])

        # Check that the register a0 contains the malloc error code (should be 26)
        t.check_scalar("a0", 26)

        # Generate the test assembly file and run it through venus
        t.execute()


    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        # Input the length of the desired array
        array_length = 5
        t.input_scalar("a0", array_length)

        # Call the `initialize_zero` function
        t.call("initialize_zero")

        # Check that the register a0 contains the correct array (hint: use check_array_pointer)
        t.check_array_pointer("a0", array_length, [0, 0, 0, 0, 0])

        t.execute()

    def test_array_length_less_than_one(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        # Input the length of the desired array
        array_length = 0
        t.input_scalar("a0", array_length)

        # Call the `initialize_zero` function and expect a0 to be 36
        t.call("initialize_zero", expected_return_code=36)

        t.execute()

    def test_malloc_error(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        # Input the length of the desired array
        array_length = 10
        t.input_scalar("a0", array_length)

        # Call the `initialize_zero` function and expect a0 to be 26
        t.call("initialize_zero", expected_return_code=26)

        t.execute()


    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
