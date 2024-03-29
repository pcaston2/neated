import 'package:neated/genome.dart';
import 'package:neated/neuralNet.dart';
import 'package:neated/node.dart';
import 'package:neated/connection.dart';
import 'package:test/test.dart';

void main() {
  test('neural net', () {
    //Arrange
    var nn = NeuralNet(0,1);
    //Act
    var json = nn.toJson();
    nn = NeuralNet.fromJson(json);
    //Assert
    expect(nn.inputs, equals(0));
    expect(nn.outputs, equals(1));
    expect(nn.species.length, equals(0));
  });

  test('populated neural net', () {
    //Arrange
    var nn = NeuralNet(0,1);
    nn.createNextGeneration();
    //Act
    var json = nn.toJson();
    nn = NeuralNet.fromJson(json);
    //Assert
    expect(nn.inputs, equals(0));
    expect(nn.outputs, equals(1));
    expect(nn.species, isNotEmpty);
  });

  test('genome', () {
    //Arrange
    var g = Genome(1,1);
    var originalLink = g.addLink(g.bias, g.outputs.single);
    originalLink.weight = 0.8;
    originalLink.enabled = false;
    g.addNode(originalLink);
    g.addLoop(g.outputs.single);
    //Act
    var json = g.toJson();
    g = Genome.fromJson(json);
    //Assert
    var link = g.links.single;
    expect(g.inputCount, equals(1));
    expect(g.outputCount, equals(1));
    expect(link.identifier, equals('(0,2)'));
    expect(link.enabled, isFalse);
    expect(link.weight, equals(0.8));
    expect(link.depth, equals(1));
    var neuron = g.hiddens.single;
    expect(neuron.identifier, equals("{0,2}"));
    expect(neuron.depth, equals(1));
    expect(g.genes.length, equals(6));
  });

  test('bias', () {
    //Arrange
    var bias = Bias();
    bias.depth = 2;
    //Act
    var json = bias.toJson();
    bias = Bias.fromJson(json);
    //Assert
    expect(bias.identifier, equals("0"));
    expect(bias.depth, equals(2));
    expect(bias.canLoop, isFalse);
    expect(json['type'], equals('Bias'));
  });

  test('input', () {
    //Arrange
    var input = Input.index(2);
    input.depth = 2;
    //Act
    var json = input.toJson();
    input = Input.fromJson(json);
    //Assert
    expect(input.identifier, equals("2"));
    expect(input.depth, equals(2));
    expect(input.canLoop, isFalse);
    expect(json['type'], equals('Input'));
  });


  test('output', () {
    //Arrange
    var output = Output.index(3);
    output.depth = 4;
    //Act
    var json = output.toJson();
    output = Output.fromJson(json);
    //Assert
    expect(output.identifier, equals("3"));
    expect(output.depth, equals(4));
    expect(output.canLoop, isFalse);
    expect(json['type'], equals('Output'));
  });

  test('hidden', () {
    //Arrange
    var link = Link(Bias(), Output.index(1));
    var genes = [link];
    var hidden = Hidden(link);
    hidden.depth = 4;
    //Act
    var json = hidden.toJson();
    hidden = Hidden.fromJsonWithGenes(json, genes);
    //Assert
    expect(hidden.identifier, equals("{0,1}"));
    expect(hidden.depth, equals(4));
    expect(hidden.canLoop, isTrue);
    expect(json['type'], equals('Hidden'));
  });

  test('link', () {
    //Arrange
    var bias = Bias();
    var output = Output.index(1);
    var genes = [bias, output];
    var originalLink = Link(bias, output);
    originalLink.enabled = false;
    originalLink.weight = 0.75;
    //Act
    var json = originalLink.toJson();
    var link = Link.fromJsonWithGenes(json, genes);
    //Assert
    expect(link.enabled, isFalse);
    expect(link.weight, equals(0.75));
    expect(link.depth, equals(1));
    expect(link.identifier, equals('(0,1)'));
  });

  test('loop', () {
    //Arrange
    var output = Output.index(1);
    var genes = [output];
    var originalLoop = Loop.around(output);
    originalLoop.enabled = false;
    originalLoop.weight = 0.65;
    //Act
    var json = originalLoop.toJson();
    var loop = Loop.fromJsonWithGenes(json, genes);
    //Assert
    expect(loop.enabled, isFalse);
    expect(loop.weight, equals(0.65));
    expect(loop.depth, equals(1));
    expect(loop.identifier, equals('(1)'));
  });
}