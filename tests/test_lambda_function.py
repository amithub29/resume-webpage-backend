import unittest
from resume_backend.lambda_function import lambda_handler

class TestLambda(unittest.TestCase):

    def test_lambda_handler(self):
        response = lambda_handler(None, None)
        self.assertEqual(response['statusCode'], 200)

if __name__ == '__main__':
    unittest.main()
