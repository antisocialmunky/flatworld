'use strict';

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var Matter = _interopDefault(require('matter-js'));

// src\js\types\neuron.coffee
var Neuron;

var Neuron$1 = Neuron = (function() {
  Neuron.prototype.bias = 0;

  Neuron.prototype.activationFn = null;

  function Neuron(bias, activationFn) {
    this.bias = bias;
    this.activationFn = activationFn;
  }

  return Neuron;

})();

// src\js\types\block.coffee
var Block;

var Block$1 = Block = (function() {
  Block.prototype.inputs = null;

  Block.prototype.hiddens = null;

  Block.prototype.outputs = null;

  function Block() {
    this.inputs = [];
    this.hiddens = [];
    this.outputs = [];
  }

  Block.prototype.addInput = function(bias, fn) {
    return this.inputs.push(new Neuron$1(bias, fn));
  };

  Block.prototype.addHidden = function(bias) {
    return this.hiddens.push(new Neuron$1(bias));
  };

  Block.prototype.addOutput = function(bias, fn) {
    return this.outputs.push(new Neuron$1(bias, fn));
  };

  return Block;

})();

// src\js\types\constants.coffee
var minSize = 12;

var maxSize = 24;

var sizeRange = maxSize - minSize;

var minDistance = 64;

var maxDistance = 128;

var distanceRange = maxDistance - minDistance;

// src\js\types\bodyblock.coffee
var BodyBlock;
var PI;
var TAU;
var cos;
var sin;
var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp = {}.hasOwnProperty;

PI = Math.PI;

TAU = PI * 2;

cos = Math.cos;

sin = Math.sin;

var BodyBlock$1 = BodyBlock = (function(superClass) {
  extend(BodyBlock, superClass);

  BodyBlock.prototype.b = 0;

  BodyBlock.prototype.distance = 0;

  BodyBlock.prototype.angle = 0;

  BodyBlock.prototype.x = 0;

  BodyBlock.prototype.y = 0;

  BodyBlock.prototype.size = 0;

  BodyBlock.prototype.collisions = 0;

  BodyBlock.prototype.body = null;

  BodyBlock.prototype.primeBlock = null;

  BodyBlock.prototype.type = 'body-block';

  function BodyBlock(b1, primeBlock1) {
    var b, c, d, offsetX, offsetY, primeBlock;
    this.b = b1 != null ? b1 : 0;
    this.primeBlock = primeBlock1;
    BodyBlock.__super__.constructor.apply(this, arguments);
    b = this.b;
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0;
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0;
    primeBlock = this.primeBlock;
    this.size = b % sizeRange + minSize;
    this.distance = b % distanceRange + minDistance;
    this.angle = (b + primeBlock.body.angle) % TAU;
    offsetX = this.distance * cos(this.angle);
    offsetY = this.distance * sin(this.angle);
    this.x = offsetX + primeBlock.body.position.x;
    this.y = offsetY + primeBlock.body.position.y;
    this.body = Matter.Bodies.circle(this.x, this.y, this.size, {
      angle: this.angle
    });
    this.body._parentBlock = this;
    this.addInput(b - c, (function(_this) {
      return function() {
        var ret;
        ret = _this.collisions;
        _this.collisions = 0;
        return _this.collisions;
      };
    })(this));
    this.addInput(c - d, (function(_this) {
      return function() {
        return (_this.body.angle - _this.primeBlock.body.angle + TAU) % TAU;
      };
    })(this));
  }

  BodyBlock.prototype.oncollisionActive = function() {
    return this.collisions++;
  };

  return BodyBlock;

})(Block$1);

// src\js\types\muscleblock.coffee
var Constraint;
var MuscleBlock;
var extend$1 = function(child, parent) { for (var key in parent) { if (hasProp$1.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp$1 = {}.hasOwnProperty;

Constraint = Matter.Constraint;

var MuscleBlock$1 = MuscleBlock = (function(superClass) {
  extend$1(MuscleBlock, superClass);

  MuscleBlock.prototype.b = 0;

  MuscleBlock.prototype.stiffness = 0;

  MuscleBlock.prototype.distance = 0;

  MuscleBlock.prototype.blockA = null;

  MuscleBlock.prototype.blockB = null;

  MuscleBlock.prototype.body = null;

  MuscleBlock.prototype.primeBlock = null;

  MuscleBlock.prototype.length1 = 0;

  MuscleBlock.prototype.length2 = 0;

  MuscleBlock.prototype.length = 0;

  MuscleBlock.prototype.lengthRange = 0;

  MuscleBlock.prototype.type = 'muscle-block';

  function MuscleBlock(b1, primeBlock, blocks) {
    var b, c, d, i1, i2, numBlocks, ref, ref1;
    this.b = b1;
    this.primeBlock = primeBlock;
    MuscleBlock.__super__.constructor.apply(this, arguments);
    if (blocks.length === 0) {
      return;
    }
    b = this.b;
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0;
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0;
    this.stiffness = b % 1;
    numBlocks = blocks.length + 1;
    i1 = Math.round(b) % numBlocks;
    i2 = Math.round(c) % numBlocks;
    if (i1 === i2) {
      i2 = (i2 + 1) % numBlocks;
    }
    this.blockA = (ref = blocks[i1 - 1]) != null ? ref : this.primeBlock;
    this.blockB = (ref1 = blocks[i2 - 1]) != null ? ref1 : this.primeBlock;
    this.connectMuscle(this.blockA);
    this.connectMuscle(this.blockB);
    this.length = b % distanceRange + minDistance;
    this.length1 = this.length * .5;
    this.length2 = this.length * 1.5;
    this.lengthRange = this.length2 - this.length1;
    this.body = Constraint.create({
      bodyA: this.blockA.body,
      pointA: {
        x: b % minSize - minSize / 2,
        y: (b - c) % minSize - minSize / 2
      },
      bodyB: this.blockB.body,
      pointB: {
        x: c % minSize - minSize / 2,
        y: (c - d) % minSize - minSize / 2
      },
      stiffness: .9,
      damping: 0.01,
      length: this.length,
      render: {
        lineWidth: 1
      }
    });
    this.body._parentBlock = this;
    this.addInput(b - c, (function(_this) {
      return function() {
        return (_this.length - _this.length1) / _this.lengthRange;
      };
    })(this));
    this.addOutput(c - d, (function(_this) {
      return function(percent) {
        return _this.length = _this.body.length = _this.lengthRange * percent + _this.length1;
      };
    })(this));
  }

  MuscleBlock.prototype.connectMuscle = function(block) {
    if (block._muscles == null) {
      return block._muscles = [this];
    } else {
      return block._muscles.push(this);
    }
  };

  return MuscleBlock;

})(Block$1);

// src\js\types\thinkblock.coffee
var PI$1;
var TAU$1;
var ThinkBlock;
var cos$1;
var sin$1;
var extend$2 = function(child, parent) { for (var key in parent) { if (hasProp$2.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp$2 = {}.hasOwnProperty;

PI$1 = Math.PI;

TAU$1 = PI$1 * 2;

cos$1 = Math.cos;

sin$1 = Math.sin;

var ThinkBlock$1 = ThinkBlock = (function(superClass) {
  extend$2(ThinkBlock, superClass);

  ThinkBlock.prototype.b = 0;

  ThinkBlock.prototype.c = 0;

  ThinkBlock.prototype.distance = 0;

  ThinkBlock.prototype.angle = 0;

  ThinkBlock.prototype.x = 0;

  ThinkBlock.prototype.y = 0;

  ThinkBlock.prototype.bias = 0;

  ThinkBlock.prototype.body = null;

  ThinkBlock.prototype.primeBlock = null;

  ThinkBlock.prototype.type = 'think-block';

  function ThinkBlock(b1, primeBlock1) {
    var b, offsetX, offsetY, primeBlock;
    this.b = b1 != null ? b1 : 0;
    this.primeBlock = primeBlock1;
    ThinkBlock.__super__.constructor.apply(this, arguments);
    b = this.b;
    primeBlock = this.primeBlock;
    this.distance = b % distanceRange + minDistance;
    this.angle = (b + primeBlock.body.angle) % TAU$1;
    offsetX = this.distance * cos$1(this.angle);
    offsetY = this.distance * sin$1(this.angle);
    this.x = offsetX + primeBlock.body.position.x;
    this.y = offsetY + primeBlock.body.position.y;
    this.body = Matter.Bodies.circle(this.x, this.y, 12, {
      angle: this.angle
    });
    this.body._parentBlock = this;
    this.addHidden(b - (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10);
  }

  return ThinkBlock;

})(Block$1);

// src\js\types\goblock.coffee
var GoBlock;
var PI$2;
var TAU$2;
var cos$2;
var sin$2;
var extend$3 = function(child, parent) { for (var key in parent) { if (hasProp$3.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp$3 = {}.hasOwnProperty;

PI$2 = Math.PI;

TAU$2 = PI$2 * 2;

cos$2 = Math.cos;

sin$2 = Math.sin;

var GoBlock$1 = GoBlock = (function(superClass) {
  extend$3(GoBlock, superClass);

  GoBlock.prototype.b = 0;

  GoBlock.prototype.distance = 0;

  GoBlock.prototype.angle = 0;

  GoBlock.prototype.x = 0;

  GoBlock.prototype.y = 0;

  GoBlock.prototype.force = 0;

  GoBlock.prototype.maxForce = 0;

  GoBlock.prototype.collisions = 0;

  GoBlock.prototype.body = null;

  GoBlock.prototype.primeBlock = null;

  GoBlock.prototype.type = 'go-block';

  function GoBlock(b1, primeBlock1) {
    var b, c, d, offsetX, offsetY, primeBlock;
    this.b = b1;
    this.primeBlock = primeBlock1;
    GoBlock.__super__.constructor.apply(this, arguments);
    primeBlock = this.primeBlock;
    b = this.b;
    c = (b % Math.floor(Math.pow(10, Math.floor(Math.log10(b))))) * 10 || 0;
    d = (c % Math.floor(Math.pow(10, Math.floor(Math.log10(c))))) * 10 || 0;
    this.size = 20;
    this.distance = b % distanceRange + minDistance;
    this.angle = (b + primeBlock.body.angle) % TAU$2;
    offsetX = this.distance * cos$2(this.angle);
    offsetY = this.distance * sin$2(this.angle);
    this.x = offsetX + primeBlock.body.position.x;
    this.y = offsetY + primeBlock.body.position.y;
    this.maxForce = b % 0.0001;
    this.body = Matter.Bodies.rectangle(this.x, this.y, this.size, this.size, {
      angle: this.angle
    });
    this.body._parentBlock = this;
    this.addInput(b - c, (function(_this) {
      return function() {
        return _this.force / _this.maxForce;
      };
    })(this));
    this.addInput(c - d, (function(_this) {
      return function() {
        return (_this.body.angle - primeBlock.body.angle + TAU$2) % TAU$2;
      };
    })(this));
    this.addOutput(b - d, (function(_this) {
      return function(percent) {
        var radius;
        _this.force = Math.round(percent) * _this.maxForce;
        radius = _this.size / 2;
        return Matter.Body.applyForce(_this.body, {
          x: -cos$2(_this.body.angle) * radius,
          y: -sin$2(_this.body.angle) * radius
        }, {
          x: cos$2(_this.body.angle) * _this.force,
          y: sin$2(_this.body.angle) * _this.force
        });
      };
    })(this));
  }

  return GoBlock;

})(Block$1);

// src\js\types\gene.coffee
var Gene;

var Gene$1 = Gene = (function() {
  Gene.prototype.a = 0;

  Gene.prototype.b = 0;

  Gene.prototype.sequence = null;

  function Gene(a, b, sequence) {
    this.a = a != null ? a : 0;
    this.b = b != null ? b : 0;
    this.sequence = sequence != null ? sequence : [];
  }

  Gene.prototype._toBodyBlock = function(primeBlock) {
    return new BodyBlock$1(this.b, primeBlock);
  };

  Gene.prototype._toThinkBlock = function(primeBlock) {
    return new ThinkBlock$1(this.b, primeBlock);
  };

  Gene.prototype._toGoBlock = function(primeBlock) {
    return new GoBlock$1(this.b, primeBlock);
  };

  Gene.prototype._toMuscleBlock = function(primeBlock, blocks) {
    return new MuscleBlock$1(this.b, primeBlock, blocks);
  };

  Gene.toGenes = function(genums) {
    var gene, genes, i;
    if (genums == null) {
      genums = [];
    }
    genes = [];
    gene = [];
    i = 0;
    while (i < genums.length) {
      if (genums[i] < 18) {
        gene = [genums[i], 1, [genums[i]]];
        genes.push(gene);
      } else if (gene.length > 0) {
        if (i % 2 === 0) {
          gene[1] *= genums[i] - 17;
        } else {
          gene[1] /= genums[i] - 17;
        }
        gene[2].push(genums[i]);
      }
      i++;
    }
    return genes.map(function(gene) {
      return new Gene(gene[0], gene[1], gene[2]);
    });
  };

  Gene.toBlocks = function(primeBlock, genes) {
    var blocks, gene, j, k, len, len1, muscles;
    if (genes == null) {
      genes = [];
    }
    blocks = [];
    muscles = [];
    for (j = 0, len = genes.length; j < len; j++) {
      gene = genes[j];
      if (gene.a < 4) {
        blocks.push(gene._toBodyBlock(primeBlock));
      } else if (gene.a < 8) {
        blocks.push(gene._toThinkBlock(primeBlock));
      } else if (gene.a < 12) {
        blocks.push(gene._toGoBlock(primeBlock));
      }
    }
    if (blocks.length === 0) {
      return blocks;
    }
    for (k = 0, len1 = genes.length; k < len1; k++) {
      gene = genes[k];
      if (gene.a > 11 && gene.a < 18) {
        muscles.push(gene._toMuscleBlock(primeBlock, blocks));
      }
    }
    return blocks.concat(muscles);
  };

  return Gene;

})();

// src\js\types\primeblock.coffee
var Bodies$1;
var Body$1;
var PrimeBlock;
var TAU$3;
var extend$4 = function(child, parent) { for (var key in parent) { if (hasProp$4.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp$4 = {}.hasOwnProperty;

Bodies$1 = Matter.Bodies;

Body$1 = Matter.Body;

TAU$3 = Math.PI * 2;

var PrimeBlock$1 = PrimeBlock = (function(superClass) {
  extend$4(PrimeBlock, superClass);

  PrimeBlock.x = 0;

  PrimeBlock.y = 0;

  PrimeBlock.angle = 0;

  PrimeBlock.prototype.body = null;

  PrimeBlock.prototype.type = 'prime-block';

  function PrimeBlock(x, y, angle) {
    this.x = x != null ? x : 0;
    this.y = y != null ? y : 0;
    this.angle = angle != null ? angle : (Math.random() * 1000) % TAU$3;
    PrimeBlock.__super__.constructor.apply(this, arguments);
    this.body = Matter.Bodies.circle(this.x, this.y, 24, {
      angle: this.angle
    });
    this.body._parentBlock = this;
    this.addHidden(0);
  }

  return PrimeBlock;

})(Block$1);

// src\js\types\organism.coffee
var Bodies;
var Body;
var Constraint$1;
var Layer;
var Network;
var Organism;

Bodies = Matter.Bodies;

Body = Matter.Body;

Constraint$1 = Matter.Constraint;

Network = synaptic.Network;

Layer = synaptic.Layer;

var Organism$1 = Organism = (function() {
  Organism.count = 0;

  Organism.prototype.id = 0;

  Organism.prototype.genums = null;

  Organism.prototype.genes = null;

  Organism.prototype.primeBlock = null;

  Organism.prototype.blocks = null;

  Organism.prototype.bodies = null;

  Organism.prototype.inputs = null;

  Organism.prototype.hiddens = null;

  Organism.prototype.outputs = null;

  Organism.prototype.perceptron = null;

  function Organism(genums1) {
    var bodies, body, j, len, ref, ref1;
    this.genums = genums1 != null ? genums1 : [];
    this.id = Organism.count++;
    this.primeBlock = new PrimeBlock$1();
    this.genes = Organism._compileGenes(this.genums);
    this.blocks = Organism._compileBlocks(this.primeBlock, this.genes);
    if (this.blocks.length === 0) {
      return;
    }
    this.bodies = Organism._compileBodies(this.blocks);
    this.nonConstraints = bodies = [];
    ref = this.bodies;
    for (j = 0, len = ref.length; j < len; j++) {
      body = ref[j];
      if (body._parentBlock.type !== 'muscle-block') {
        bodies.push(body);
      }
    }
    ref1 = Organism._compilePerceptronLayers(this.blocks), this.inputs = ref1[0], this.hiddens = ref1[1], this.outputs = ref1[2];
    this.perceptron = Organism._compilePerceptron(this.inputs, this.hiddens, this.outputs);
  }

  Organism.prototype.getBodies = function() {
    var ref;
    return (ref = this.bodies) != null ? ref : [this.primeBlock.body];
  };

  Organism.prototype.getNonConstraints = function() {
    var ref;
    return (ref = this.nonConstraints) != null ? ref : [this.primeBlock.body];
  };

  Organism.prototype.think = function() {
    var i, input, inputData, j, len, output, outputData, ref, results;
    if (this.perceptron == null) {
      return;
    }
    inputData = (function() {
      var j, len, ref, results;
      ref = this.inputs;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        input = ref[j];
        results.push(input.activationFn());
      }
      return results;
    }).call(this);
    outputData = this.perceptron.activate(inputData);
    ref = this.outputs;
    results = [];
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      output = ref[i];
      results.push(this.outputs[i].activationFn(outputData[i]));
    }
    return results;
  };

  Organism.prototype.fitness = function() {
    var block, body, j, len, mass, position, ref, sx, sy;
    body = this.primeBlock.body;
    position = body.position;
    sx = position.x;
    sy = position.y;
    mass = body.mass;
    ref = this.blocks;
    for (j = 0, len = ref.length; j < len; j++) {
      block = ref[j];
      body = block.body;
      position = body.position;
      if (!position) {
        continue;
      }
      sx += position.x * body.mass;
      sy += position.y * body.mass;
      mass += body.mass;
    }
    sx /= mass;
    sy /= mass;
    return Math.sqrt(sx * sx + sy * sy) / 100;
  };

  Organism._compileGenes = function(genums) {
    return Gene$1.toGenes(genums);
  };

  Organism._compileBlocks = function(primeBlock, genes) {
    var block, blockA, blockB, connectedBlocks, connectedFilter, i, initialBlocks, j, len, muscle, ref;
    initialBlocks = Gene$1.toBlocks(primeBlock, genes);
    this._idBlocks(initialBlocks);
    i = 0;
    connectedFilter = {};
    connectedBlocks = [primeBlock];
    while (connectedBlocks[i]) {
      block = connectedBlocks[i];
      connectedFilter[block._id] = true;
      switch (block.type) {
        case 'muscle-block':
          blockA = block.blockA;
          blockB = block.blockB;
          if (!connectedFilter[blockA._id]) {
            connectedBlocks.push(blockA);
            connectedFilter[blockA._id] = true;
          }
          if (!connectedFilter[blockB._id]) {
            connectedBlocks.push(blockB);
            connectedFilter[blockB._id] = true;
          }
          break;
        default:
          if (block._muscles) {
            ref = block._muscles;
            for (j = 0, len = ref.length; j < len; j++) {
              muscle = ref[j];
              if (!connectedFilter[muscle._id]) {
                connectedBlocks.push(muscle);
                connectedFilter[muscle._id] = true;
              }
            }
          }
      }
      i++;
    }
    this._idBlocks(connectedBlocks);
    return connectedBlocks;
  };

  Organism._idBlocks = function(blocks) {
    var block, i, j, len, results;
    results = [];
    for (i = j = 0, len = blocks.length; j < len; i = ++j) {
      block = blocks[i];
      results.push(block._id = i);
    }
    return results;
  };

  Organism._compileBodies = function(blocks) {
    var block;
    return (function() {
      var j, len, results;
      results = [];
      for (j = 0, len = blocks.length; j < len; j++) {
        block = blocks[j];
        results.push(block.body);
      }
      return results;
    })();
  };

  Organism._compilePerceptronLayers = function(blocks) {
    var block, hiddens, inputs, j, len, outputs;
    inputs = [];
    hiddens = [];
    outputs = [];
    for (j = 0, len = blocks.length; j < len; j++) {
      block = blocks[j];
      inputs = inputs.concat(block.inputs);
      hiddens = hiddens.concat(block.hiddens);
      outputs = outputs.concat(block.outputs);
    }
    return [inputs, hiddens, outputs];
  };

  Organism._compilePerceptron = function(inputs, hiddens, outputs) {
    var h, hiddenLayer, i, input, inputLayer, j, k, l, len, len1, len2, output, outputLayer;
    if (inputs.length && hiddens.length && outputs.length) {
      inputLayer = new Layer(inputs.length);
      for (i = j = 0, len = inputs.length; j < len; i = ++j) {
        input = inputs[i];
        inputLayer.list[i].bias = input.bias;
      }
      hiddenLayer = new Layer(hiddens.length);
      for (i = k = 0, len1 = hiddens.length; k < len1; i = ++k) {
        h = hiddens[i];
        hiddenLayer.list[i].bias = h.bias;
      }
      outputLayer = new Layer(outputs.length);
      for (i = l = 0, len2 = outputs.length; l < len2; i = ++l) {
        output = outputs[i];
        outputLayer.list[i].bias = output.bias;
      }
      inputLayer.project(hiddenLayer);
      hiddenLayer.project(outputLayer);
      return new Network({
        input: inputLayer,
        hidden: [hiddenLayer],
        output: outputLayer
      });
    }
    return null;
  };

  return Organism;

})();

// src\js\types\hexgrid.coffee
var HexGrid;

var HexGrid$1 = HexGrid = (function() {
  function HexGrid() {}

  return HexGrid;

})();

// src\js\types\sparsemap.coffee
var SparseMap;
var extend$5 = function(child, parent) { for (var key in parent) { if (hasProp$5.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
var hasProp$5 = {}.hasOwnProperty;

var SparseList = (function() {
  SparseList.prototype.list = null;

  SparseList.prototype.keys = null;

  function SparseList(list, offset) {
    var i, j, len, x;
    if (offset == null) {
      offset = 0;
    }
    this.list = {};
    this.keys = [];
    if (list != null) {
      for (i = j = 0, len = list.length; j < len; i = ++j) {
        x = list[i];
        this.set(i + offset, x);
      }
    }
  }

  SparseList.prototype.set = function(searchKey, x) {
    var found, i, kI, ref;
    ref = this._getKeyIndex(searchKey), kI = ref[0], found = ref[1];
    if (found) {
      i = this.keys[this.kI];
      if (x != null) {
        return this.list[i] = x;
      } else {
        this.keys.splice(kI, 1);
        delete this.list[i];
        return x;
      }
    }
    if (x == null) {
      return x;
    }
    if (kI < 0) {
      this.keys.unshift(searchKey);
    } else {
      this.keys.splice(kI, 0, searchKey);
    }
    this.list[searchKey] = x;
    return x;
  };

  SparseList.prototype.get = function(searchKey) {
    var found, kI, ref;
    ref = this._getKeyIndex(searchKey), kI = ref[0], found = ref[1];
    if (!found) {
      return null;
    }
    return this.list[this.keys[kI]];
  };

  SparseList.prototype._getKeyIndex = function(searchKey) {
    var currentIndex, currentKey, insertIndex, keys, maxIndex, minIndex, ref, ref1, ref2, shiftRight;
    keys = this.keys;
    minIndex = 0;
    maxIndex = keys.length - 1;
    insertIndex = (ref = (minIndex + maxIndex) / 2) != null ? ref : 0;
    currentIndex = Math.round(insertIndex);
    currentKey = null;
    shiftRight = false;
    while (minIndex <= maxIndex) {
      currentKey = keys[currentIndex];
      if (currentKey < searchKey) {
        minIndex = currentIndex + 1;
        insertIndex = (ref1 = (minIndex + maxIndex) / 2) != null ? ref1 : 0;
        currentIndex = Math.ceil(insertIndex);
      } else if (currentKey > searchKey) {
        maxIndex = currentIndex - 1;
        insertIndex = (ref2 = (minIndex + maxIndex) / 2) != null ? ref2 : 0;
        currentIndex = Math.floor(insertIndex);
      } else {
        console.log('Found ', searchKey, '@', currentIndex);
        return [currentIndex, true];
      }
    }
    console.log('Not found ', searchKey, '@', currentIndex);
    return [Math.ceil(insertIndex), false];
  };

  SparseList.prototype.map = function() {};

  return SparseList;

})();

var SparseMap$1 = SparseMap = (function(superClass) {
  extend$5(SparseMap, superClass);

  function SparseMap() {
    SparseMap.__super__.constructor.apply(this, arguments);
  }

  return SparseMap;

})(SparseList);

// src\js\cjs.coffee
var exports$1;

exports$1 = {
  Block: Block$1,
  BodyBlock: BodyBlock$1,
  Constants: {
    minSize: minSize,
    maxSize: maxSize,
    sizeRange: sizeRange,
    minDistance: minDistance,
    maxDistance: maxDistance,
    distanceRange: distanceRange
  },
  Gene: Gene$1,
  GenumsFactory: Gene$1,
  GoBlock: GoBlock$1,
  MuscleBlock: MuscleBlock$1,
  Neuron: Neuron$1,
  Organsim: Organism$1,
  Primeblock: PrimeBlock$1,
  HexGrid: HexGrid$1,
  SparseList: SparseList,
  SparseMap: SparseMap$1
};

var exports$2 = exports$1;

module.exports = exports$2;
//# sourceMappingURL=types.js.map
