expect = chai?.expect or require('chai').expect

describe 'Embed Code', ->

  it 'should load the embed code', -> 
    expect(MyGovLoader).to.be.ok
  
  it 'should load the bar', ->
    MyGovLoader.show()
    expect( jQuery( 'iframe#myGovBar' ).length ).to.not.equal(0)

if window?.requirejs
  define (require) -> {}