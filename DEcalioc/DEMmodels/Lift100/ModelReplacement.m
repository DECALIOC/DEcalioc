function out = ModelReplacement(dummy)
  pkg load stk
  x = csvread('params.csv');
  load 'models.mod'
  m = stk_predict(model_mass, params, mass, x).mean;
  d = stk_predict(model_density, params, density, x).mean;
  csvwrite('output_mass', m);
  csvwrite('output_density', d);
end