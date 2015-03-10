
void reset() {
  
  for (int i = 0; i < balls.size (); i++) {
    balls.get(i).destroy();
  }
  
  joints = new ArrayList<FDistanceJoint>();
  anchors = new ArrayList<Node>();
  balls = new ArrayList<Node>();
  createMinim();
  
  world.clear();
  //world.setEdges();

  float padding = anchorSize/2;

  createAnchor(padding, padding);
  createAnchor(width-padding, padding);
  createAnchor(width-padding, height-padding);
  createAnchor(padding, height-padding);

  createAnchor(width/2, height-padding);
  createAnchor(padding, height/2);
  createAnchor(width-padding, height/2);
  createAnchor(width/2, padding);
}

void createAnchor( float x, float y) {

  Node tmp = new Node(anchorSize);
  tmp.setFill(255);
  tmp.setStatic(true);
  tmp.setNoStroke();
  tmp.setPosition(x, y);
  anchors.add(tmp);
  world.add(tmp);
}

void randomize() {

  Node tmp;
  float padding = 350; 
  ArrayList<Node> circles = new ArrayList<Node>();

  for ( int i = 0; i < randomAmount; i++) {

    tmp = new Node(ballSize);
    tmp.setFill(500);
    tmp.setNoStroke();
    tmp.setRestitution(0);
    tmp.setFriction(0);
    tmp.setDamping(0);
    tmp.setDensity(1);
    tmp.setRotatable(false);
    tmp.setPosition( random(padding, width-padding), random(padding, height-padding) );
    circles.add(tmp);
    balls.add(tmp);
    world.add(tmp);
  }

  for ( int i = 0; i < circles.size (); i++ ) {
    for ( int j = 0; j < circles.size (); j++ ) {
      if (random(100) > 100 - probability) {
        FDistanceJoint dj = new FDistanceJoint(circles.get(i), circles.get(j));
        dj.setStroke(255);
        dj.setLength(globLength);
        dj.setFrequency(globFreq);
        dj.setDamping(globDamp);
        joints.add(dj);
        world.add(dj);
      }
    }
  }

  for (int i = 0; i < anchors.size (); i++) {

    int rand = floor(random(circles.size()));
    FDistanceJoint dj = new FDistanceJoint(anchors.get(i), circles.get(rand));
    dj.setStroke(255);
    dj.setLength(globLength);
    dj.setFrequency(globFreq);
    dj.setDamping(globDamp);
    joints.add(dj);
    world.add(dj);
  }
}

void connectNeighbors(ArrayList<Node> list) {
  
  for ( int i = 0; i < list.size (); i++ ) {
    
    Node left = list.get(i);
    
    float minDist = 1000000000;
    FBody closeNeighbor = null;  

    for ( int j = 0; j < balls.size (); j++ ) {
      
      Node right = balls.get(j);
      
      if ( left == right ) continue;
      if ( isConnected(left, right) ) {
        continue;
      }
      
      float newDist = dist( left.getX(), left.getY(), right.getX(), right.getY() ); 
      if ( minDist > newDist) {
        minDist = newDist;
        closeNeighbor = right;
      }
    }

    if (closeNeighbor == null) continue;

    FDistanceJoint dj = new FDistanceJoint(left, closeNeighbor);
    dj.setStroke(255);
    dj.setLength(globLength);
    dj.setFrequency(globFreq);
    dj.setDamping(globDamp);
    joints.add(dj);
    world.add(dj);
  }
}

boolean isConnected(FBody left, FBody right) {
  
  for( int i = 0; i < joints.size(); i++ ) {
    if( joints.get(i).getBody1() == left && joints.get(i).getBody2() == right)  return true;
    if( joints.get(i).getBody1() == right && joints.get(i).getBody2() == left)  return true; 
  }
  return false;
}

void shockWave(){
  for ( int j = 0; j < balls.size (); j++ ) {
    if(dist(mouseX, mouseY, balls.get(j).getX(), balls.get(j).getY()) < 300 ) {
      balls.get(j).addImpulse( mouseX - balls.get(j).getX() * 10 , mouseY - balls.get(j).getY() * 10); 
    }
  }
}

void updateFrequency(float freq) {

  for ( int i = 0; i < joints.size (); i++ ) {
    joints.get(i).setFrequency(freq);
  }
}

void updateDamping(float damp) {

  for ( int i = 0; i < joints.size (); i++ ) {
    joints.get(i).setDamping(damp);
  }
}

void updateLength(float len) {

  for ( int i = 0; i < joints.size (); i++ ) {
    joints.get(i).setLength(len);
  }
}

void updateBallSize(float size) {

  for ( int i = 0; i < balls.size (); i++ ) {
    balls.get(i).setSize(size);
  }
}

