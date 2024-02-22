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

  describe('when input values change', () => {
    it('passes the correct query string to fetch', async () => {
      global.fetch.mockClear();

      let testRenderer;
      await act(async () => {
        testRenderer = renderer.create(<Home />);
      });

      const testInstance = testRenderer.root;

      // Simulate changing the input fields
      const companyNameInput = testInstance.findByProps({ id: 'company-name' });
      await act(async () => {
        companyNameInput.props.onChange({ target: { value: 'Test Company' } });
      });

      const industryInput = testInstance.findByProps({ id: 'industry' });
      await act(async () => {
        industryInput.props.onChange({ target: { value: 'Test Industry' } });
      });

      const minEmployeeInput = testInstance.findByProps({ id: 'min-employee' });
      await act(async () => {
        minEmployeeInput.props.onChange({ target: { value: '100' } });
      });

      const minDealAmountInput = testInstance.findByProps({ id: 'min-amount' });
      await act(async () => {
        minDealAmountInput.props.onChange({ target: { value: '1000' } });
      });

      expect(global.fetch).toHaveBeenCalledTimes(5);
      expect(global.fetch).toHaveBeenLastCalledWith(expect.stringContaining('/api/v1/companies?'));
      expect(global.fetch).toHaveBeenLastCalledWith(expect.stringContaining('name=Test+Company'));
      expect(global.fetch).toHaveBeenLastCalledWith(expect.stringContaining('industry=Test+Industry'));
      expect(global.fetch).toHaveBeenLastCalledWith(expect.stringContaining('employeeCount=100'));
      expect(global.fetch).toHaveBeenLastCalledWith(expect.stringContaining('dealAmount=1000'));
    });
  });
});
