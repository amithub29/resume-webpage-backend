import unittest
from resume_backend import lambda_function

class TestLambda(unittest.TestCase):

    def test_lambda_handler(self):
        response = lambda_function.lambda_handler(None, None)
        self.assertEqual(response['statusCode'], 200)

if __name__ == '__main__':
    unittest.main()
