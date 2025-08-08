from app.app import app

def main(request):
    return app(request.environ, start_response=None)
