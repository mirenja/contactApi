import functions_framework
from app.app import app

@functions_framework.http
def entry_point(request):
    
    with app.request_context(request.environ):
        return app.full_dispatch_request()