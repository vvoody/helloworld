from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.api import urlfetch

# Free jump the shorten url to the original long url
# Many shortend url services like bit.ly, j.mp are bloody damn
# blocked in some countries.

# Use like: http://yourapp.appspot.com/freejump?url=http://biy.ly/fuckGFW

class MainPage(webapp.RequestHandler):
    def get(self):
        short_url = self.request.get('url')
        result = urlfetch.fetch(url=short_url,
                                method='HEAD',
                                follow_redirects=False)
        if result.status_code in (301,302):
            self.redirect(result.headers['Location'])
            # Not setting follow_redirects to False, we can use the final_url
            # self.redirect(result.final_url)
        else:
            self.redirect(short_url)

application = webapp.WSGIApplication([('/freejump', MainPage)], debug=True)

def main():
    run_wsgi_app(application)

if __name__ == '__main__':
    main()
