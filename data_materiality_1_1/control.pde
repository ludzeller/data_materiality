
void handleControl() {

  if (mouseReleased && keyPressed) {

    if (key == 'a') {

      if (world.getBody(mouseX, mouseY) == null) { // only create new on empty spot
        Node tmp = new Node(ballSize);
        tmp.setFill(255);
        tmp.setNoStroke();
        tmp.setPosition(mouseX, mouseY);
        world.add(tmp);
        balls.add(tmp);
        prev = null; // reset connection builder
      }
    } else if (key == 'f') {

      if (world.getBody(mouseX, mouseY) == null) { // only create new on empty spot
        Node tmp = new Node(anchorSize);
        tmp.setFill(255);
        tmp.setNoStroke();
        tmp.setPosition(mouseX, mouseY);
        tmp.setStatic(true);
        world.add(tmp);
        anchors.add(tmp);
        prev = null; // reset connection builder
      }
    } else if ( key == 'd' ) { // start marking for deletion

      world.remove(world.getBody(mouseX, mouseY));
    } else if (key == 's') {

      if (prev == null) {
        prev = world.getBody(mouseX, mouseY);
      } else if ( prev != null && world.getBody(mouseX, mouseY) == null ) { // cancel link
        prev = null;
      } else {
        FBody current = world.getBody(mouseX, mouseY);
        FDistanceJoint dj = new FDistanceJoint( prev, current );
        dj.setStroke(255);
        dj.setLength(globLength);
        dj.setFrequency(globFreq);
        dj.setDamping(globDamp);
        joints.add(dj);
        world.add(dj);
        prev = current; // for daisychaining
      }
    }
  }

  if (keyPressed) {
    if (key == 'w') {
      globDamp =  map(mouseX, 0, width, 0, 2);
      updateDamping( globDamp );
    } 

    if (key == 'q') {
      globFreq =  map(mouseX, 0, width, 0, 10);
      updateFrequency( globFreq );
    }

    if (key == 'e') {
      globLength =  map(mouseX, 0, width, 5, 200);
      updateLength( globLength );
    }

    if (key == 't') {
      probability =  map(mouseX, 0, width, 0, 100);
    }

    if (key == 'z') {
      randomAmount =  round(map(mouseX, 0, width, 2, 50));
    }

    if (key == 'u') {
      ballSize = round(map(mouseX, 0, width, 2, 50));
      //updateBallSize(ballSize);
    }
    
    if (key == 'g') {
      world.setGravity( width/2 - mouseX, height/2 - mouseY  ) ;
      //updateBallSize(ballSize);
    }

    if (key == 'c') {
      reset();
    }
  }

  mouseReleased = false;
}




void mouseReleased() {
  mouseReleased = true;
}

void keyPressed() {
  if (key == 'r') {
    reset();
    randomize();
  }

  if (key == 'n') {
    connectNeighbors(balls);
  }
  if (key == 'm') {

    connectNeighbors(anchors);
  }

  if (key == 'p') {
    paused = !paused;
  }

  if (key == 'x') {
    shockWave();
  }
}

