import React from 'react';
import Home from './Home'
import renderer, { act } from 'react-test-renderer';

global.fetch = jest.fn(() =>
  Promise.resolve({
    json: () => Promise.resolve([]),
  })
);

describe('Home', () => {
  it('renders correctly', async () => {
    let tree;

    await act(async () => {
      tree = renderer.create(<Home />);
    });

    expect(tree).toMatchSnapshot();
  });
});
