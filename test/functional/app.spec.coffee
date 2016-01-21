app = require '../../app/app.coffee'
expect = require('chai').expect
request = require 'supertest'


describe 'app', () ->


  describe 'GET the homepage', () ->


    it "should show hello world", (done) ->
      request(app)
        .get('/')
        .end (err, res) ->
          if err then return done(err)
          expect(res.statusCode).to.equal(200)
          expect(res.text).to.include('<h1>Hello World</h1>')
          done()