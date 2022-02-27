#Simple Pong Game

import turtle
import winsound

wn = turtle.Screen()
wn.title('PONG')
wn.bgcolor('black')
wn.setup(width=800, height=600)
wn.tracer(0)

#Score
score_a = 0
score_b = 0

#paddle A
paddle_a = turtle.Turtle()
paddle_a.speed(0)# '0'--fastest For animation
paddle_a.shape('square')
paddle_a.shapesize(stretch_len=1, stretch_wid=5)
paddle_a.color('white')
paddle_a.penup()#when moved no drawings
paddle_a.goto(-350,0)

#paddle B
paddle_b = turtle.Turtle()
paddle_b.speed(0)# '0'--fastest For animation
paddle_b.shape('square')
paddle_b.shapesize(stretch_len=1, stretch_wid=5)
paddle_b.color('white')
paddle_b.penup()#when moved no drawings
paddle_b.goto(350,0)

#Ball
ball = turtle.Turtle()
ball.speed(0)
ball.shape('circle')
ball.color('white')
ball.penup()
ball.goto(0,0)
ball.dx = 0.1
ball.dy = 0.1

#pen
pen = turtle.Turtle()
pen.speed(0)
pen.penup()
pen.color('white')
pen.hideturtle()
pen.goto(0,260)
pen.write('Player A: 0  Player B: 0',align='center' ,font = ('Courier',18,'normal'))

#Function to move paddle A up
def paddle_a_up():
    y = paddle_a.ycor()
    y+=30
    paddle_a.sety(y)

#Function to move paddle A down
def paddle_a_down():
    y = paddle_a.ycor()
    y-=30
    paddle_a.sety(y)

#Function to move paddle B up
def paddle_b_up():
    y = paddle_b.ycor()
    y+=30
    paddle_b.sety(y)

#Function to move paddle B down
def paddle_b_down():
    y = paddle_b.ycor()
    y-=30
    paddle_b.sety(y)


#keybord Binding
wn.listen()
#for A
wn.onkeypress(paddle_a_up,'w')
wn.onkeypress(paddle_a_down,'s')
#for B
wn.onkeypress(paddle_b_up,'Up')
wn.onkeypress(paddle_b_down,'Down')


#Main game loop
while True:
    wn.update()

    #Moving the Ball-- Sets of ball moving in diagonal direction 
    ball.setx(ball.xcor()+ ball.dx)
    ball.sety(ball.ycor()+ ball.dy)

    #borderline checking
    if ball.ycor() > 290:
        ball.sety(290)
        ball.dy *= -1 #reverses the direction
        winsound.PlaySound('bounce.wav',winsound.SND_ASYNC)
        

    if ball.ycor() < -290:
        ball.sety(-290)
        ball.dy *= -1 #reverses the direction
        winsound.PlaySound('bounce.wav',winsound.SND_ASYNC)
        

    if ball.xcor() > 390:
        ball.goto(0,0)
        ball.dx *= -1
        score_a+=1
        pen.clear()
        pen.write('Player A: {}  Player B: {}'.format(score_a,score_b),align='center' ,font = ('Courier',18,'normal'))

    if ball.xcor() < -390:
        ball.goto(0,0)
        ball.dx *= -1
        score_b+=1
        pen.clear()
        pen.write('Player A: {}  Player B: {}'.format(score_a,score_b),align='center' ,font = ('Courier',18,'normal'))

    #ball and paddle collision:
    if (ball.xcor() > 340 and ball.xcor() < 350) and (ball.ycor()< paddle_b.ycor() + 40 and ball.ycor() > paddle_b.ycor()-40 ):
        ball.setx(340)
        ball.dx *= -1
        winsound.PlaySound('bounce.wav',winsound.SND_ASYNC)

    if (ball.xcor() < -340 and ball.xcor() > -350) and (ball.ycor()< paddle_a.ycor() + 40 and ball.ycor() > paddle_a.ycor()-40 ):
        ball.setx(-340)
        ball.dx *= -1
        winsound.PlaySound('bounce.wav',winsound.SND_ASYNC)

    #Paddle movement on moving off the screen
    if paddle_a.ycor()+40<-290:
        paddle_a.sety(260)

    if paddle_a.ycor()-40>290:
        paddle_a.sety(-260)

    if paddle_b.ycor()+40<-290:
        paddle_b.sety(260)

    if paddle_b.ycor()-40>290:
        paddle_b.sety(-260)
        


